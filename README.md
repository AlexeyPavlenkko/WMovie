# Stack
- Programmaticall UI | MVVM | CoreData | WebView

# Screens info
- Home Tab: 5 network Requests placed into DispatchGroup and results(movies) are despalyed in CollectionViewCompositionalLayout. 
- Upcoming Tab: Shows upcoming movies and loading more of them when bottom of tableView is reached. Movie's release date > .now
- Search Tab: 2 Search Scopes(movies/tvShows). When search button's clicked, network request is being made and (movies/tvShows)'re being shown.
- Downloads Tab: Shows content that is stored locally on device (CoreData). Table view is reloading because of NSFetchedResultsController.
- MovieDetail Screen: Shows selected movie details and webView is loading youtube trailer of this movie if one exists.

# Sceens screenshots
<img width="938" alt="screen" src="https://user-images.githubusercontent.com/108945278/193863024-3fcd843b-41b8-40ac-98dc-ca696ae1dcd0.png">

# App showcase 
![wmovie](https://user-images.githubusercontent.com/108945278/193863074-2b3fb195-f187-4fdd-b7b2-cb0909196a9b.gif)

# App Showcase (no wifi situation)
![wmovieNoWiFi](https://user-images.githubusercontent.com/108945278/193863268-bcc436f6-901e-47a0-b234-2ec2c093bed5.gif)
