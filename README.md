# Games Feature Specs

```http
  BASE_URL:  https://api.rawg.io/
```

[API Documentation](https://rawg.io/apidocs)

## Use Cases

### Load Games From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Games List" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates Games List from valid data.
5. System delivers Games List.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

### Search Games From Remote Use Case

#### Data:
- URL
- Query

#### Primary course (happy path):
1. Execute "Search Games List" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates Games List from valid data.
5. System delivers Games List.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.


# Flowchart

## Games List
![Screenshot 2023-02-21 at 23 39 32](https://user-images.githubusercontent.com/33575723/220406009-bacba0b7-9479-4f8d-b59f-f8a31cf47fb4.png)

## Search games 
![Screenshot 2023-02-21 at 23 41 22](https://user-images.githubusercontent.com/33575723/220406442-329de8ae-b1ae-4bdf-8b73-8610615a254b.png)


## Model Specs

### Game Item

| Property | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `id` | `Int` | Game ID |
| `title` | `String` | Game Title |
| `releaseDate` | `String` | Game Release Date |
| `rating` | `Double` | Game Rating |
| `image` | `URL` | Game image URL |


#### Payload contract

```http
  GET /api/games?key={api_key}&page_size={page_size}&page={page}&search={query}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `api_key`      | `String` | **Required**. Your API key. |
| `page_size`      | `Int` | **Required**. Total item that fetched. |
| `page`      | `Int` | **Required**. Page number to fetched. |
| `search`      | `String` | **Required**. Query for searching data. |

### 
```
200 RESPONSE

{
    "count": 874450,
    "next": "https://api.rawg.io/api/games?key=375107cb63db476a86598ff9936da3c4&page=3&page_size=1",
    "previous": "https://api.rawg.io/api/games?key=375107cb63db476a86598ff9936da3c4&page_size=1",
    "results": [
        {
            "id": 3328,
            "slug": "the-witcher-3-wild-hunt",
            "name": "The Witcher 3: Wild Hunt",
            "released": "2015-05-18",
            "tba": false,
            "background_image": "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg",
            "rating": 4.66,
            "rating_top": 5,
            "ratings": [
                {
                    "id": 5,
                    "title": "exceptional",
                    "count": 4593,
                    "percent": 77.61
                }
                ...
            ],
            "ratings_count": 5833,
            "reviews_text_count": 59,
            "added": 18041,
            "added_by_status": {
                "yet": 1026,
                "owned": 10400,
                "beaten": 4258,
                "toplay": 710,
                "dropped": 812,
                "playing": 835
            },
            "metacritic": 92,
            "playtime": 46,
            "suggestions_count": 654,
            "updated": "2023-02-21T16:02:09",
            "user_game": null,
            "reviews_count": 5918,
            "saturated_color": "0f0f0f",
            "dominant_color": "0f0f0f",
            "platforms": [
                {
                    "platform": {
                        "id": 186,
                        "name": "Xbox Series S/X",
                        "slug": "xbox-series-x",
                        "image": null,
                        "year_end": null,
                        "year_start": 2020,
                        "games_count": 719,
                        "image_background": "https://media.rawg.io/media/games/121/1213f8b9b0a26307e672cf51f34882f8.jpg"
                    },
                    "released_at": "2015-05-18",
                    "requirements_en": null,
                    "requirements_ru": null
                },
                {
                    "platform": {
                        "id": 18,
                        "name": "PlayStation 4",
                        "slug": "playstation4",
                        "image": null,
                        "year_end": null,
                        "year_start": null,
                        "games_count": 6575,
                        "image_background": "https://media.rawg.io/media/games/942/9424d6bb763dc38d9378b488603c87fa.jpg"
                    },
                    "released_at": "2015-05-18",
                    "requirements_en": null,
                    "requirements_ru": null
                }
                ...
            ],
            "parent_platforms": [
                {
                    "platform": {
                        "id": 1,
                        "name": "PC",
                        "slug": "pc"
                    }
                }
                ...
            ],
            "genres": [
                {
                    "id": 4,
                    "name": "Action",
                    "slug": "action",
                    "games_count": 175463,
                    "image_background": "https://media.rawg.io/media/games/c4b/c4b0cab189e73432de3a250d8cf1c84e.jpg"
                }
                ...
            ],
            "stores": [
                {
                    "id": 354780,
                    "store": {
                        "id": 5,
                        "name": "GOG",
                        "slug": "gog",
                        "domain": "gog.com",
                        "games_count": 4852,
                        "image_background": "https://media.rawg.io/media/games/713/713269608dc8f2f40f5a670a14b2de94.jpg"
                    }
                }
                ...
            ],
            "clip": null,
            "tags": [
                {
                    "id": 31,
                    "name": "Singleplayer",
                    "slug": "singleplayer",
                    "language": "eng",
                    "games_count": 205593,
                    "image_background": "https://media.rawg.io/media/games/120/1201a40e4364557b124392ee50317b99.jpg"
                }
                ...
            ],
            "esrb_rating": {
                "id": 4,
                "name": "Mature",
                "slug": "mature"
            },
            "short_screenshots": [
                {
                    "id": -1,
                    "image": "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg"
                }
                ...
            ]
        }
    ],
    "seo_title": "All Games",
    "seo_description": "",
    "seo_keywords": "",
    "seo_h1": "All Games",
    "noindex": false,
    "nofollow": false,
    "description": "",
    "filters": {
        "years": [
            {
                "from": 2020,
                "to": 2023,
                "filter": "2020-01-01,2023-12-31",
                "decade": 2020,
                "years": [
                    {
                        "year": 2023,
                        "count": 26219,
                        "nofollow": false
                    }
                    ...
                ],
                "nofollow": true,
                "count": 510379
            },
            {
                "from": 2010,
                "to": 2019,
                "filter": "2010-01-01,2019-12-31",
                "decade": 2010,
                "years": [
                    {
                        "year": 2019,
                        "count": 79746,
                        "nofollow": false
                    }
                    ...
                ],
                "nofollow": true,
                "count": 311222
            }
            ...
        ]
    },
    "nofollow_collections": [
        "stores"
    ]
}
```

# Game Detail and Favorite Feature Specs

### Load Favorite games From Cache Use Case

#### Data:
- isFavorite = true

#### Primary course (happy path):
1. Execute "Get Favorite games List" command with above data.
2. System retrieves data from cache.
3. System validates cache isFavorite true.
4. System creates Favorite Games List from cached data.
5. System delivers Favorite Games List.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache error course (sad path):
1. System delivers empty data error.

### Retrieve Game detail data From Cache Use Case

#### Data:
- Game ID

#### Primary course (happy path):
1. Execute "Get game detail" command with above data.
2. System retrieves data from cache.
4. System creates game detail from cached data.
5. System delivers game detail.

#### Retrival error course (sad path):
1. System delivers data error.

#### Empty cache course (sad path):
1. System delivers empty data error.

### Load Game Detail From Remote Use Case

#### Data:
- URL
- Game ID

#### Primary course (happy path):
1. Execute "Load game detail" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates game detail from valid data.
5. System delivers game detail.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.


### Cache Game Detail Data Use Case

#### Data:
- Game Detail Item

#### Primary course (happy path):
1. Execute "Save Game Detail" command with above data.
2. System caches game detail data.
3. System delivers success message.

#### Saving error course (sad path):
1. System delivers error.

### Add Favorite Games to Cache

#### Data:
- Game Detail Item

#### Primary course (happy path):
1. Execute "Add to Favorite" command with above data.
2. System update cache isFavorite data.
3. System delivers success message.

#### Fail to update – error course (sad path):
1. System delivers fail update error.



# Flowchart
## Favorite Games List
![Screenshot 2023-02-21 at 23 57 19](https://user-images.githubusercontent.com/33575723/220410360-9ed2cb2b-a896-495a-b134-5c31a249aa1e.png)

## Game Detail 
![Screenshot 2023-02-21 at 23 59 12](https://user-images.githubusercontent.com/33575723/220410782-cac348bb-fd75-4e4e-b86f-523e81d93170.png)

## Favorite action
![Screenshot 2023-02-22 at 00 00 35](https://user-images.githubusercontent.com/33575723/220411113-09210db0-3437-4103-a628-f4d00e90a198.png)

## Model Specs

### Game Detail Item

| Property | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `id` | `Int` | Game ID |
| `title` | `String` | Game Title |
| `releaseDate` | `String` | Game Release Date |
| `rating` | `Double` | Game Rating |
| `image` | `URL` | Game image URL |
| `description` | `String` | Game description |
| `played` | `Int` | Game total game played |
| `developers` | `String` | Game developer name |
| `isFavorite` | `Bool` | Is this favorite game? |


#### Payload contract

```http
  GET /api/games/{game_id}?key={api_key}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `api_key`      | `String` | **Required**. Your API key. |
| `game_id`      | `Int` | **Required**. Game ID. |

### 
```
200 RESPONSE

{
    "id": 3498,
    "slug": "grand-theft-auto-v",
    "name": "Grand Theft Auto V",
    "name_original": "Grand Theft Auto V",
    "description": "<p>Rockstar Games went bigger, since their previous installment of the series.....<p>",
    "metacritic": 92,
    "metacritic_platforms": [
        {
            "metascore": 96,
            "url": "https://www.metacritic.com/game/pc/grand-theft-auto-v",
            "platform": {
                "platform": 4,
                "name": "PC",
                "slug": "pc"
            }
        }
        ...
    ],
    "released": "2013-09-17",
    "tba": false,
    "updated": "2023-02-21T16:05:25",
    "background_image": "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
    "background_image_additional": "https://media.rawg.io/media/screenshots/5f5/5f5a38a222252d996b18962806eed707.jpg",
    "website": "http://www.rockstargames.com/V/",
    "rating": 4.47,
    "rating_top": 5,
    "ratings": [
        {
            "id": 5,
            "title": "exceptional",
            "count": 3697,
            "percent": 59.03
        }
        ...
    ],
    "reactions": {
        "1": 27,
        "2": 8
        ....
    },
    "added": 18921,
    "added_by_status": {
        "yet": 488,
        "owned": 10966,
        "beaten": 5262,
        "toplay": 551,
        "dropped": 977,
        "playing": 677
    },
    "playtime": 73,
    "screenshots_count": 57,
    "movies_count": 8,
    "creators_count": 11,
    "achievements_count": 539,
    "parent_achievements_count": 75,
    "reddit_url": "https://www.reddit.com/r/GrandTheftAutoV/",
    "reddit_name": "/r/GrandTheftAutoV",
    "reddit_description": "/r/GrandTheftAutoV - the subreddit for all GTA V related news, content, and discussions revolving around Rockstar's critically acclaimed single player release and the ongoing multiplayer expansion of Grand Theft Auto Online.",
    "reddit_logo": "",
    "reddit_count": 5084,
    "twitch_count": 160,
    "youtube_count": 1000000,
    "reviews_text_count": 84,
    "ratings_count": 6179,
    "suggestions_count": 412,
    "alternative_names": [
        "GTA 5",
        "GTA V",
        "GTA5",
        "GTAV"
    ],
    "metacritic_url": "https://www.metacritic.com/game/pc/grand-theft-auto-v",
    "parents_count": 0,
    "additions_count": 3,
    "game_series_count": 9,
    "user_game": null,
    "reviews_count": 6263,
    "saturated_color": "0f0f0f",
    "dominant_color": "0f0f0f",
    "parent_platforms": [
        {
            "platform": {
                "id": 1,
                "name": "PC",
                "slug": "pc"
            }
        }
        ...
    ],
    "platforms": [
        {
            "platform": {
                "id": 187,
                "name": "PlayStation 5",
                "slug": "playstation5",
                "image": null,
                "year_end": null,
                "year_start": 2020,
                "games_count": 802,
                "image_background": "https://media.rawg.io/media/games/739/73990e3ec9f43a9e8ecafe207fa4f368.jpg"
            },
            "released_at": "2013-09-17",
            "requirements": {}
        }
        ...
    ],
    "stores": [
        {
            "id": 290375,
            "url": "",
            "store": {
                "id": 3,
                "name": "PlayStation Store",
                "slug": "playstation-store",
                "domain": "store.playstation.com",
                "games_count": 7794,
                "image_background": "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg"
            }
        }
        ...
    ],
    "developers": [
        {
            "id": 3524,
            "name": "Rockstar North",
            "slug": "rockstar-north",
            "games_count": 29,
            "image_background": "https://media.rawg.io/media/screenshots/b98/b98adb52b2123a14d1c88e828a6b49f3.jpg"
        }
        ...
    ],
    "genres": [
        {
            "id": 4,
            "name": "Action",
            "slug": "action",
            "games_count": 175463,
            "image_background": "https://media.rawg.io/media/games/c4b/c4b0cab189e73432de3a250d8cf1c84e.jpg"
        }
        ...
    ],
    "tags": [
        {
            "id": 31,
            "name": "Singleplayer",
            "slug": "singleplayer",
            "language": "eng",
            "games_count": 205593,
            "image_background": "https://media.rawg.io/media/games/120/1201a40e4364557b124392ee50317b99.jpg"
        }
        ...
    ],
    "publishers": [
        {
            "id": 2155,
            "name": "Rockstar Games",
            "slug": "rockstar-games",
            "games_count": 78,
            "image_background": "https://media.rawg.io/media/games/d1c/d1c676bd2b8b9d909ccaefb15b8554f5.jpg"
        }
    ],
    "esrb_rating": {
        "id": 4,
        "name": "Mature",
        "slug": "mature"
    },
    "clip": null,
    "description_raw": "Rockstar Games went bigger, since their previous installment of the series....."
}
```
