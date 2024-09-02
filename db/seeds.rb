# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

omar = User.create!(
    fullname: "Omar Torres",
    city: "Lima",
    bio: "I'm a software engineer",
    picture: "https://randomuser.me/api/portraits/thumb/men/75.jpg",
    email: "omartorres@example.com",
    password: "12345678"
  )

  martha = User.create!(
    fullname: "Martha Dons",
    city: "Manchester",
    bio: "I'm a professor and philosopher at Cambridge University. In my spare time I love exploring other topics such as Politics, Economics and Intelligence. ",
    picture: "https://randomuser.me/api/portraits/thumb/men/75.jpg",
    email: "martha@example.com",
    password: "12345678"
  )

  # Martha's explorations

marthaExploration1 = Exploration.create!(
  text: "What are the reason behind people working in tech and finance. I've worked for almost a year on this and I'm eager to explore these topics.",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: martha.id
)

marthaExploration2 = Exploration.create!(
  text: "Exploration 2",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: martha.id
)

marthaExploration3 = Exploration.create!(
  text: "Exploration 3",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: martha.id
)

  # Omar's explorations

Exploration.create!(
  text: "I’m interested in exploring the previous events that led Churchill decide to fight and confront Hitler despite all the high probabilities of loosing. Why he was so stubborn, courageous and optimistic. What was happening in the England oh his time that pushed him to have this attitude.",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: omar.id,
  shared_exploration_ids: [marthaExploration1.id, marthaExploration2.id]
)

Exploration.create!(
  text: "I'm interested in exploring the viscitutes of findind your special one through dating apps. Given the complexity of social life nowadays, the question of Should we rely on this digital approaches? arises so rapidly.",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: omar.id
)

Exploration.create!(
  text: "I'm interested in exploring the various methodologies that led to the champions of Chess in 1999 to win the all their matches. It is definitely something I'm captivating by and would love to see different ideas of the causes.",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: omar.id
)

Exploration.create!(
  text: "I'm interested in exploring all the games that are the smartest people in the world playing. I want to be an intellectual, develop  my own ideas some day and share it with the world.",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: omar.id
)

Exploration.create!(
  text: "I'm interested in exploring the different categories of philosophy of mind because I'm about to enter the industry of AI and would like to merge these two topics.",
  sources: ["http://www.some-url1.com", "http://www.some-url2.com", "http://www.some-url3.com"],
  user_id: omar.id
)