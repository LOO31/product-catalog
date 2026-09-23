# Product Catalog

This is a simple Product Catalog app built with Flutter for the Junior Mobile Developer technical assessment.

The app uses the DummyJSON API to load and search for products.

## Features

- View product title, image and price
- Load more products when scrolling
- View product details
- Search products with a 500ms debounce
- Loading, error and empty states
- Retry when loading fails
- Pull-to-refresh
- Image loading and error handling
- Unit test for Product JSON parsing

## Tech Stack

- Flutter
- Dart
- HTTP
- DummyJSON API

## Project Structure

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

- `models` - stores the product data
- `services` - handles API requests
- `screens` - contains the UI and user interaction

I separated the API logic from the UI to keep the code easier to manage.

## API

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

I used the DummyJSON search API instead of only filtering the products that are already loaded.

I also added a 500ms debounce to avoid sending a request for every character typed.

## How to Run

1. Make sure Flutter is installed.
2. Clone the repository.
3. Open the project.
4. Install the dependencies:

```bash
flutter pub get
```

5. Start an Android emulator or connect an Android device.
6. Run:

```bash
flutter run
```

## Testing

Run the test with:

```bash
flutter test
```

The test checks if the Product model can convert JSON data correctly.

## TODO

If I had more time, I would add more tests and continue improving the UI.

## AI Assistance

I used AI for guidance, troubleshooting, and some implementation examples while working on the project. I reviewed and tested the final code and made sure I understand the implementation.