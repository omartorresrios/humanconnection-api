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
      similarExplorations = Exploration.where(id: similarExplorationIds)
      Notification.create(recipient: currentUser, actor: currentUser, notifiable: newExploration, explorations: similarExplorations)
      apnsNotifyCurrentUserWhoCreatedTheExploration(currentUser, newExplorationId)
      addNewExplorationToItsSimilarExplorationsAndNotifyTheirCreators(similarExplorationIds, currentUser, newExploration)
    end
  end

  def apnsNotifyCurrentUserWhoCreatedTheExploration(currentUser, newExplorationId)
    unreadNotifications = Notification.where(recipient: currentUser).unread.count
    payload = {
      "message": {
        "token": "#{currentUser.fcm_token}",
        "notification": {
          "body": "People with similar explorations to the one you just published.",
          "title": "Keep exploring"
        },
        "apns": {
          "payload": {
            "aps": {
              "sound": "default",
              "badge": unreadNotifications
            }
          }
        },
        "data": {
          "exploration_id": "#{newExplorationId}"
        }
      }
    }
    apnsNotifyUser(payload)
  end

  def apnsNotifyUser(payload)
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(ENV['FIREBASE_SDK_CREDENTIALS']),
      scope: 'https://www.googleapis.com/auth/firebase.messaging')
    token = authorizer.fetch_access_token!
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{token['access_token']}"
    }
    response = HTTParty.post("https://fcm.googleapis.com/v1/projects/#{ENV['FIREBASE_PROJECT_ID']}/messages:send", body: payload.to_json, headers: headers)
  end

  def addNewExplorationToItsSimilarExplorationsAndNotifyTheirCreators(similarExplorationIds, currentUser, newExploration)
    usersToNotify = []
    userHash = { "user" => nil, "exploration_ids" => [] }
    similarExplorations = Exploration.where(id: similarExplorationIds)
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
      Notification.create(recipient: user["user"], actor: currentUser, notifiable: newExploration, explorations: similarExplorations)
      apnsNotifySimilarExplorationUser(user["user"], user["exploration_ids"], newExploration.id, currentUser.fullname)
    }
  end

  def apnsNotifySimilarExplorationUser(user, explorationIds, newExplorationId, currentUserFullname)
    unreadNotifications = Notification.where(recipient: user).unread.count
    payload = {
      "message": {
        "token": "#{user.fcm_token}",
        "notification": {
          "body": "#{currentUserFullname} just published an exploration similar to one of yours.",
          "title": "Start exploring"
        },
        "apns": {
          "payload": {
            "aps": {
              "sound": "default",
              "badge": unreadNotifications
            }
          }
        },
        "data": {
          "exploration_ids": "#{explorationIds}",
          "similar_exploration_id": "#{newExplorationId}"
        }
      }
    }
    apnsNotifyUser(payload)
  end
end