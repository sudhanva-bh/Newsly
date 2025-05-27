# Newsly – Flutter News Reader App

**Newsly** is a modern, full-featured news reader app built with Flutter. It aggregates news from multiple sources, provides weather and stock updates, and allows users to bookmark articles for later reading. The app is designed to be fast, visually appealing, and easy to use, with a focus on delivering a personalized and informative experience.

🚨 **IMPORTANT:** Before running the app, please create a `.env` file in the root directory of the project with your API keys
---




## Features

### 📰 News Aggregation
- **Breaking News & World News:**  
  Fetches the latest breaking and world news from multiple reputable sources using the [NewsData.io](https://newsdata.io/) API.
- **Local News:**  
  Users can filter news by country and category, making it easy to stay updated on local events.
- **Hot Topics Carousel:**  
  A sliding carousel highlights trending topics and top stories.

### 🌦️ Weather Updates
- **Current Weather:**  
  Displays the current weather for the user's location, including temperature, condition, humidity, wind speed, and pressure.
- **Forecast:**  
  Fetches and displays a 5-day weather forecast using the [OpenWeatherMap](https://openweathermap.org/) API.

### 💹 Stock Market
- **Stock Quotes:**  
  Shows real-time stock prices and daily changes for popular companies using the [Finnhub](https://finnhub.io/) API.

### 🔖 Bookmarks
- **Save Articles:**  
  Users can bookmark articles with a single tap or double-tap gesture.
- **Bookmark Management:**  
  View, add, and remove bookmarks from a dedicated page.

### 🔍 Search & Navigation
- **Search Bar:**  
  Quickly search for news articles by keyword.
- **Bottom Navigation:**  
  Easily switch between Home, Local News, and Bookmarks tabs.
- **In-App WebView:**  
  Read full articles in-app or open them in the browser if content is missing.

### 🎨 UI/UX
- **Material Design:**  
  Clean, modern interface with smooth animations and responsive layouts.
- **Dark/Light Mode:**  
  Theme toggling for comfortable reading in any environment.
- **Loading & Error States:**  
  Custom skeletons and animations for loading and error handling.

---

## Project Structure

- **lib/**
  - **Pages/** – Main screens (Home, Bookmarks, Local News, Weather, Expanded Article)
  - **Services/** – API service classes for news, weather, and stocks
  - **Widgets/** – Reusable UI components (cards, navigation, selectors, etc.)
  - **utils.dart** – Utility functions and models
  - **home_page.dart** – Main app shell with navigation
  - **main.dart** – App entry point and provider setup

---

## How It Works

1. **API Integration:**  
   The app fetches news, weather, and stock data from external APIs using HTTP requests. API keys are loaded from a .env file for security.
2. **State Management:**  
   Uses the [Provider](https://pub.dev/packages/provider) package for managing bookmarks and app-wide state.
3. **Navigation:**  
   Implements both bottom navigation and in-app navigation for a seamless user experience.
4. **Customization:**  
   Users can filter news by country and category, bookmark articles, and view detailed weather and stock info.

---

## Getting Started

1. **Clone the repository**
2. **Install dependencies**
   ```
   flutter pub get
   ```
3. **Set up your .env file**  
🚨 **IMPORTANT:** Before running the app, please create a `.env` file in the root directory of the project with your API keys:  
   Add your API keys for NewsData.io, OpenWeatherMap, and Finnhub:
   ```
   NEWS_API_KEY=your_newsdata_api_key
   WEATHER_API_KEY=your_openweathermap_api_key
   STOCK_API_KEY=your_finnhub_api_key
   ```
5. **Run the app**
   ```
   flutter run
   ```

---

## Dependencies

- [Flutter](https://flutter.dev/)
- [Provider](https://pub.dev/packages/provider)
- [http](https://pub.dev/packages/http)
- [loading_animation_widget](https://pub.dev/packages/loading_animation_widget)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- [dropdown_search](https://pub.dev/packages/dropdown_search)
- [webview_flutter](https://pub.dev/packages/webview_flutter)
- [geolocator](https://pub.dev/packages/geolocator)
- [geocoding](https://pub.dev/packages/geocoding)
- [intl](https://pub.dev/packages/intl)
- [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator)

---

## Customization & Extensibility

- **Add More APIs:**  
  Easily extend the app to support more news sources, weather providers, or financial data.
- **UI Themes:**  
  Customize colors, fonts, and layouts to match your brand or preferences.
- **Offline Support:**  
  Implement caching for offline reading (future enhancement).
---

**Newsly** – Stay informed, stay inspired.  
Built with ❤️ using Flutter.
