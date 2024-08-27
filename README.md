# Catering Manager
## Simplifying Event Catering with Automated Planning and Real-Time Management
<div style="text-align: center;">
    <img src="https://github.com/user-attachments/assets/f672374a-71c1-4550-a537-c4aa60b5e79d" width="300" />
</div>
Catering Manager is an application designed to simplify the organization of catering events for businesses. It helps manage menus, store new events, automatically calculate costs based on the number of guests, generate shopping lists for ingredients, and now includes push notifications to remind users of upcoming events.

## Updated Features

- **User Authentication**: Secure login and registration using Firebase Authentication.
- **Events Management**: Create, update, and delete events with detailed information. Events are stored in Firebase Firestore.
- **Menu Management**: Display available menus with detailed item lists, including dishes, ingredients, and quantities.
- **Cost Calculation**: Automatically calculate catering costs based on the number of guests.
- **Ingredient Shopping List**: Generate shopping lists based on menu selections with the quantity of ingredients.
- **Push Notifications**: Automatically receive a notification 24 hours before an event starts.
- **Data Storage**: All data, including events and menus, are securely stored in Firebase Firestore.
- **Weather API Integration**: Provides weather information for event planning.

## Project Design

The application is designed following a clean MVVM architecture, ensuring scalability and maintainability.

### Project Structure

- **Models**: Define data structures and business logic.
- **Views**: SwiftUI components for the user interface.
- **ViewModels**: Manage presentation logic, data flow, and interaction with the model.
- **Repositories**: Handle data storage and interaction with Firebase Firestore and other external services.

### Data Storage

The app uses Firebase for:
- **User Authentication**: Secure management of user accounts.
- **Firestore Database**: Store and manage events, menus, and associated data in real-time.

### API Calls

- **Weather API**: Retrieves weather data to help users plan their events considering weather conditions.

### Push Notifications

- **Push Notification Integration**: Implemented using `UNUserNotificationCenter`, the app sends reminders 24 hours before any scheduled event starts.

### 3rd-Party Frameworks

- **Firebase**: Used for user authentication, Firestore database storage, and push notifications.

## Screenshots

<p float="left">
  <img src="https://github.com/user-attachments/assets/f672374a-71c1-4550-a537-c4aa60b5e79d" width="200" />
  <img src="https://github.com/user-attachments/assets/5ab27630-d63e-4c35-b984-ed9c45479316" width="200" />
  <img src="https://github.com/user-attachments/assets/41850bc6-3912-43ed-916e-fef4553c951e" width="200" />
  <img src="https://github.com/user-attachments/assets/14e02d9e-6ab0-4450-b212-ad5e5fa5073d" width="200" />
</p>

<p float="left">
  <img src="https://github.com/user-attachments/assets/20f7388b-9c1f-4c53-9e56-7f4be69a82f6" width="200" />
  <img src="https://github.com/user-attachments/assets/02ebee7e-b273-41d6-91da-80066e6e5738" width="200" />
  <img src="https://github.com/user-attachments/assets/41cd93e1-cfdd-4e74-bd83-cd7e07b2d37e" width="200" />
  <img src="https://github.com/user-attachments/assets/33f9ed1a-1fa7-4ddf-8ea2-ee060ef205fa" width="200" />
</p>
<p float="left">
  <img src="https://github.com/user-attachments/assets/3952cbda-cf47-4f1a-b4ce-5f9c08cb1135" width="200" />
  <img src="https://github.com/user-attachments/assets/606acc79-e842-4487-828c-6fb4bdb0dd2f" width="200" />
  <img src="https://github.com/user-attachments/assets/b05e170a-fa0a-491e-9b2d-c591c77c5946" width="200" />
  <img src="https://github.com/user-attachments/assets/1b61e981-8920-4024-b153-5569f0d5db25" width="200" />
</p>
