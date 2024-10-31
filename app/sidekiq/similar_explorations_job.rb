class SimilarExplorationsJob
  include Sidekiq::Job

  def perform(currentUserId, newExplorationId, explorationText)
    explorationsToCompareDict = {}
    currentUser = User.find(currentUserId)
    Exploration.worldwide_except_from(currentUser).each { |exploration|
      explorationsToCompareDict[exploration.id] = exploration.text.gsub(/\(|\)|\;|\->/, '').gsub(/\s/, '\\')
    }
    similarExplorations = `python3 lib/python/similarity_of_explorations.py "#{explorationText}" "#{explorationsToCompareDict}"`
    similarExplorationIds = similarExplorations.gsub(/\[|\]/, '').gsub(/\'/, '').strip.split(", ")
    if !similarExplorationIds.empty?
      newExploration = Exploration.find(newExplorationId)
      newExploration.similar_exploration_ids = similarExplorationIds
      newExploration.save
      Notification.create(recipient: currentUser, actor: currentUser, exploration: newExploration)
      apnsNotifyCurrentUserWhoCreatedTheExploration(currentUser, newExploration.id)
      addNewExplorationToItsSimilarExplorationsAndNotifyTheirCreators(similarExplorationIds, currentUser, newExploration)
    end
  end

  def apnsNotifyCurrentUserWhoCreatedTheExploration(currentUser, newExplorationId)
    unreadNotifications = Notification.where(exploration_id: newExplorationId).unread.count
    notification_payload = {
      "message": {
        "token": "#{currentUser.fcm_token}",
        "notification": {
          "body": "People with similar explorations to the one you just published.",
          "title": "Keep exploring"
        },
        "apns": {
          "payload": {
            "aps": {
              "alert": {
                "title": "Keep exploring",
                "body": "People with similar explorations to the one you just published.",
              },
              "sound": "default",
              "badge": unreadNotifications,
              "content-available": 1
            }
          }
        },
        "data": {
          "exploration_id": "#{newExplorationId}"
        }
      }
    }
    apnsNotifyUser(notification_payload)
  end

  def apnsNotifyUser(payload)
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(ENV['FIREBASE_SDK_CREDENTIALS']),
      scope: 'https://www.googleapis.com/auth/firebase.messaging')
    token = authorizer.fetch_access_token!
    token = authorizer.fetch_access_token!
    puts "access token: #{token['access_token']}"
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token['access_token']}"
    }
    response = HTTParty.post("https://fcm.googleapis.com/v1/projects/#{ENV['FIREBASE_PROJECT_ID']}/messages:send", body: payload.to_json, headers: headers)
    if response.success?
      puts "Notification sent successfully!"
      puts "Response data: #{response.code}"
      puts "Response data: #{response.body}"
    else
      # it its 500, retry. so i guess checking notification was send to stop trying?
      puts "Failed to send notification."
      puts "Response code: #{response.code}"
      puts "Response message: #{response.message}"
      puts "Response body: #{response.body}"
    end
  end

  def addNewExplorationToItsSimilarExplorationsAndNotifyTheirCreators(similarExplorationIds, currentUser, newExploration)
    usersToNotify = []
    userHash = { "user" => nil, "exploration_ids" => [] }
    similarExplorationIds.each { |explorationId|
      exploration = Exploration.find(explorationId)
      exploration.similar_exploration_ids << newExploration.id
      exploration.save
      user = User.find(exploration.user_id)
      if !userHash["user"].nil?
        userHash["exploration_ids"] << exploration.id
      else
        userHash["user"] = user
        userHash["exploration_ids"] << exploration.id
        if !usersToNotify.include?(userHash)
          usersToNotify << userHash
        end
      end
    }
    usersToNotify.each { |user|
      # For each affected exploration of the same user
      # Example: Current user (Omar) has created a new exploration, and Brescia, has 3 explorations that are
      # related to Omar's new exploration. 
      user["exploration_ids"].each { |explorationId|
        exploration = Exploration.find(explorationId)
        Notification.create(recipient: user["user"], actor: currentUser, exploration: exploration)
        apnsNotifySimilarExplorationUser(user["user"], explorationId, currentUser.fullname)
      }
    }
  end

  def apnsNotifySimilarExplorationUser(otherUser, otherUserExplorationId, currentUserFullname)
    unreadNotifications = Notification.where(exploration_id: otherUserExplorationId).unread.count
    notification_payload = {
      "message": {
        "token": "#{otherUser.fcm_token}",
        "notification": {
          "body": "#{currentUserFullname} just published an exploration similar to one of yours.",
          "title": "Start exploring"
        },
        "apns": {
          "payload": {
            "aps": {
              "alert": {
                "title": "Start exploring",
                "body": "#{currentUserFullname} just published an exploration similar to one of yours.",
              },
              "sound": "default",
              "badge": unreadNotifications,
              "content-available": 1
            }
          }
        },
        "data": {
          "exploration_id": "#{otherUserExplorationId}",
        }
      }
    }
    apnsNotifyUser(notification_payload)
  end
end