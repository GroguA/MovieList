# Overview

Movie App is an iOS application designed to showcase popular movies fetched from an API. 

It features three main screens: 
- movie list screen displaying movies in a UICollectionView 
- favorites screen showing saved movies in a UITableView
- movie details screen for detailed information about each movie. 

The app is built using the VIPER architecture for modular and scalable development.

# Features
## Movie List Screen

Displays a collection of popular movies fetched from an API.
Allows users to like or dislike movies. 
Liked movies are saved locally using CoreData.
Includes a global search feature to search for movies by title across the API.
Provides navigation to the favorites screen to view saved movies.

<img src="https://github.com/GroguA/MovieList/blob/main/movieListScreens/movieListScreenLight.png?raw=true" height="400" />
<img src="https://github.com/GroguA/MovieList/blob/main/movieListScreens/movieListScreenDark.png?raw=true" height="400" />

## Movie Details Screen

Accessed by tapping on a movie from the movie list screen or favorite movies screen.

Shows the:
- movie poster
- release status
- release date
- budget
- genres
- original language
- rating
- is movie favorited.

<img src="https://github.com/GroguA/MovieList/blob/main/movieListScreens/movieDetailsScreenLight.png?raw=true" height="400" />
<img src="https://github.com/GroguA/MovieList/blob/main/movieListScreens/moviedetailsScreenDark.png?raw=true" height="400" />

## Favorites Screen

Displays a list of movies marked as favorites in a UITableView.

Allows users to view and manage their favorite movies, including removing movies from favorites.

<img src="https://github.com/GroguA/MovieList/blob/main/movieListScreens/favoriteMoviesScreenLight.png?raw=true" height="400" />
<img src="https://github.com/GroguA/MovieList/blob/main/movieListScreens/favoriteMoviesScreenDark.png?raw=true" height="400" />

# Architecture

The application is structured using the VIPER architecture, which stands for View, Interactor, Presenter, Entity, and
Router. 
This architecture separates concerns and promotes maintainability and testability of the codebase.

View: Responsible for displaying data to the user and capturing user interactions.
Interactor: Contains business logic related to fetching and manipulating data.
Presenter: Mediates between the view and the interactor, formatting data for display and reacting to user inputs.
Entity: Represents data objects used by the interactor.
Router: Handles navigation between different screens/modules within the app.

# Technologies Used

URLSession: Used for network requests to fetch movie data from the API.
AutoLayout: Used for defining the layout constraints programmatically to ensure the app's user interface adapts to
various screen sizes and orientations.
CoreData: Utilized for local storage of favorite movies.
UIKit: Provides fundamental components and controls for building the user interface.
DiffableDataSource: Implemented for both UICollectionView and UITableView to efficiently manage and update
data-driven UI components.
Service Locator: Used to manage and provide access to various services across the app, promoting loose coupling and
flexibility.
Factory Pattern: Implemented to manage the creation of various components or services in a centralized manner,
enhancing modularity and reducing dependencies.

# Note for Users in Russia

Due to regulatory requirements, users from Russia may need to use a VPN to ensure the correct operation of the
application. 
This may be necessary to access certain features or content depending on regional restrictions.
