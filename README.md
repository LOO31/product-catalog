# Product Catalog

A simple Product Catalog mobile application built with Flutter for the Junior Mobile Developer technical assessment.

The app uses the DummyJSON API to display, search, and view product information.

## Features

- Display product title, thumbnail, and price
- Load more products when scrolling using pagination
- View product details including description, price, rating, and images
- Search products with debounce
- Loading, error, empty, and success states
- Retry button when an API request fails
- Pull-to-refresh
- Image loading and error handling
- Unit test for Product JSON parsing

## Tech Stack

- Flutter
- Dart
- HTTP package
- DummyJSON REST API

## Project Structure

The project is separated into different parts:

```text
lib/
├── models/
│   └── product.dart
├── services/
│   └── product_service.dart
├── screens/
│   ├── product_list_page.dart
│   └── product_detail_page.dart
└── main.dart
```

- `models` - Product data model and JSON conversion
- `services` - Handles API requests
- `screens` - Handles the UI and user interaction

I used this structure to keep the API/data logic separate from the UI.

## API

This project uses the DummyJSON Products API.

Product list:

```text
GET /products?limit=20&skip=0
```

Product details:

```text
GET /products/{id}
```

Search:

```text
GET /products/search?q={query}
```

## Search

I chose server-side search using the DummyJSON search endpoint instead of filtering only the products already loaded on the device.

A 500ms debounce is used so the app does not send an API request for every character typed by the user.

## How to Run

1. Make sure Flutter is installed.
2. Clone this repository.
3. Open the project.
4. Install the dependencies:

```bash
flutter pub get
```

5. Start an Android emulator or connect an Android device.
6. Run the application:

```bash
flutter run
```

## Testing

Run the unit test with:

```bash
flutter test
```

The unit test checks the conversion of JSON data into a Product object.

## Incomplete / TODO

All required features are implemented.

With more time, I would improve the UI styling and add more test coverage.

## AI Assistance

AI was used minimally for guidance and research during development, such as clarifying Flutter concepts and checking implementation approaches. The application structure, implementation decisions, and final code were reviewed and understood before submission.