# Reminder App

Simple daily reminder app built with Flutter and BLoC. Reminders are stored locally and scheduled using native notifications.

## Setup

- Install Flutter and set up your IDE/emulator.
- From the project root run:
  - `flutter pub get`
  - `flutter run`
- For real devices, ensure notification permissions are granted by the OS (especially on iOS/Android 13+).

## Dependencies / Plugins

- `flutter_bloc` – state management using BLoC pattern.
- `equatable` – value equality for events and states.
- `hive` / `hive_flutter` – lightweight local key‑value storage for reminders.
- `flutter_local_notifications` – scheduling local notifications on device.
- `timezone` – correct scheduling based on the device time zone.

## Architecture (BLoC)

- `main.dart` initializes `NotificationService` and `ReminderRepository`, then provides a single `ReminderBloc` at the app root with `BlocProvider`.
- `ReminderBloc` handles `ReminderEvent`s (`LoadReminders`, `AddReminderEvent`, `UpdateReminderEvent`, `DeleteReminderEvent`, `ToggleReminderActiveEvent`) and emits `ReminderState`s (`ReminderInitial`, `ReminderLoading`, `ReminderLoaded`, `ReminderError`).
- `ReminderRepository` abstracts Hive access and coordinates scheduling/cancelling notifications via `NotificationService`.
- UI layer:
  - `HomeScreen` displays the list of reminders and exposes actions (toggle active, edit, delete) via BLoC events.
  - `ReminderFormScreen` creates/edits reminders and dispatches add/update events.

## Assumptions / Limitations

- Reminders are daily at a specific time (no custom recurrence rules or specific dates).
- Notifications depend on the platform’s permission model; if the user disables notifications, reminders will not be shown.
- Storage is local only (Hive box, no encryption by default, no cloud sync/backup).
- Time zone is taken from the device; changing the device time/zone may affect when notifications fire.
- If you schedule a reminder for a time that is already in the past for the current day (e.g. it is 11:25:10 and you schedule 11:25), it will be scheduled for the next day at that time.

## Notification Behaviour / Testing Notes

- Android:
  - Uses `POST_NOTIFICATIONS` permission on Android 13+; the system will prompt the user on first run.
  - Reminders are delivered via local notifications even when the app is in background.
- iOS:
  - The app configures `UNUserNotificationCenter.current().delegate` in `AppDelegate` and sets `defaultPresentAlert`, `defaultPresentBadge`, and `defaultPresentSound` to `true`.
  - Notifications are allowed to be presented even when the app is in the foreground (banner/sound behaviour still depends on the user’s system notification settings).
- When testing, prefer setting the reminder 1–2 minutes in the future rather than exactly the current minute to avoid it being treated as “already passed today” and moved to the next day. 

## Usage

- Tap the **+** button to create a new reminder.
- Masukkan judul dan pilih jam pengingat, lalu tap **Create Reminder**.
- Reminders akan muncul dalam daftar utama, diurutkan berdasarkan jam.
- Switch di sebelah kiri setiap item mengaktifkan/nonaktifkan reminder (mengatur penjadwalan/cancel notifikasi).
- Ikon pensil membuka form edit untuk mengubah judul atau jam.
- Ikon tempat sampah menghapus reminder beserta notifikasi terjadwalnya.

## Screenshot

ketika notification muncul di foreground
<img width="1170" height="2532" alt="simulator_screenshot_538ECBF9-6E24-40C6-8D85-3E478F20BAF0" src="https://github.com/user-attachments/assets/e1e5cb3b-90b9-474d-b04a-599df7bd752d" />



## Bonus Features

- Reminders are persisted locally and survive app restarts.
- List of reminders is automatically sorted by time.
- Toggling a reminder on/off transparently schedules or cancels the underlying notification.
- Existing reminders can be edited with form validation for the title.
