# Inpursuit Backend

This repo is to hold the backend for Inpursuit.

## Links to access database

#### To access the user table use:

https://arcane-mesa-59373.herokuapp.com/get-mock-user

## Home Feed

#### Your Picks

This call is to return posts matched with the user_interests. Return an array of objects where the user_interests.interestsId == posts.interestsId && posts.pursuitId == pursuits.pursuitId && user.userId == loggedInUser. Limit to 15.

##### Joined Tables

Posts
Pursuits
User
User_interests

#### WHERE Values

user_interests.interestsId == posts.interestsId
posts.pursuitId == pursuits.pursuitId
user.userId == posts.userId

```

{
   "your_picks" : [{
        "thumbnailUrl" : "https://photoUrl.com",
        "postId" : 1,
        "pursuitId" : 1,
        "posts_description" : "Filler Text",
        "userId" : "some-string",
        "userPhoto" : "https://photUrl.com",
        "username" : "Test"
    }]
} 
```
#### Trending Posts

This call is to return the most viewed posts. Return an array of objects where the posts.pursuitId == pursuits.pursuitId. Limit to 15. Ordered by posts_views count.

##### Joined Tables

Posts
Pursuits
User
Posts_views

#### WHERE Values

posts_views.postId = posts.postId
posts.pursuitId == pursuits.pursuitId
user.userId == posts.userId


``` 

{
    "trending_posts" : [{
        "thumbnailUrl" : "https://photoUrl.com",
        "postId" : 1,
        "pursuitId" : 1,
        "posts_description" : "Filler Text",
        "userId" : "some-string",
        "userPhoto" : "https://photUrl.com"
    }]
}

```

#### Standard Posts

This call is to return the standard (an array of the most recent) posts. Return an array of objects where the posts.pursuitId == pursuits.pursuitId && user.userId == posts.userId. Also return the details of that posts where days.pursuitId == pursuits.pursuitId && setbacks.pursuitId == pursuits.pursuitId && team.pursuitId == pursuits.pursuitId && engagements.pursuitId == pursuits.pursuitId. Limit to 15. 

##### Joined Tables

Posts
Pursuits
User
Days
Setbacks
Team
Engagements

#### WHERE Values

posts.pursuitId == pursuits.pursuitId
user.userId == posts.userId
days.pursuitId == pursuits.pursuitId
setbacks.pursuitId == pursuits.pursuitId
team.pursuitId == pursuits.pursuitId
engagements.pursuitId == pursuits.pursuitId

```

{
    "standard_posts" : [{
        "thumbnailUrl" : "https://photoUrl.com",
        "postId" : 1,
        "pursuitId" : 1,
        "posts_description" : "Filler Text",
        "userId" : "some-string",
        "username" : "Test",
        "userPhoto" : "https://photUrl.com",
        "days" : [{
            "days_active" : 30,
            "tasks_completed" : 30,
            "on_track_percentage" : 0.8
        }],
        "setbacks" : [{
            "number_of_setbacks" : 9,
            "solutions_found" : 3,
            "time_till_solution" : "3 Days"
        }],
        "team" : [{
            "userId" : 1,
            "userPhoto" : "https://photoUrl.com",
            "username" : "Test"
        }],
        "engagements" : [{
            "tries" : 5,
            "saves" : 0,
            "responses" : 20
        }]
    }]
} 

```
#### Setbacks

This call is to return setbacks. Return an array of objects where the setbacks.pursuitId == pursuits.pursuitId && setbacks.setbackId == posts.postId && user.userId == setbacks.userId. Limit to 15. 

##### Joined Tables

Setbacks
Pursuits
Posts
User

#### WHERE Values

setbacks.pursuitId == pursuits.pursuitId
setbacks.conflictId == posts.postId
user.userId == setbacks.userId

```

    "setbacks" : [{
        "thumbnailUrl" : "https://photoUrl.com",
        "days_active" : "3 Days",
        "pursuitId" : 1,
        "setback_decription" : "This is diffucult",
        "setbackId" : 2
    }]

```
#### Challenges

This call is to return challenges. Return an array of objects where the challenge.challengeId == posts.postId && user.userId == challenge.userId && challenge.challengeId == challenge_engagements.challengeId. Limit to 15. 

##### Joined Tables

Challenge
Challenge_engagements
Posts
User

#### WHERE Values

challenge.challengeId == posts.postId
challenge.challengeId == challenge_engagements.challengeId
user.userId == setbacks.userId

```

{
    "challenges" : [{
        "thumbnailUrl" : "https://photoUrl.com",
        "challengeTitle" : "This is a challenge",
        "challengeId" : 3,
        "number_of_challengers" : 3,
        "in_the_lead" : "Test",
        "time_left_for_challenge" : "3 weeks"
    }]
}

```
