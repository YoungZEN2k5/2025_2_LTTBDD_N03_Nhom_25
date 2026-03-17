# Cách code vận hành — To-Do Bloom

Tài liệu ngắn mô tả luồng chính và nơi tìm mã nguồn để hiểu/điều chỉnh hành vi ứng dụng.

## Tổng quan
- Ứng dụng là một To‑Do nhỏ viết bằng Flutter.
- Trạng thái (tasks, categories, profile, ngôn ngữ, theme) giữ trong bộ nhớ của `TodoApp` (không có persistence hiện tại).

## Điểm vào
- Entry point: [lib/main.dart](lib/main.dart)
  - `main()` thiết lập error handlers và gọi `runApp(const TodoApp())`.
  - `TodoApp` là `StatefulWidget` chứa toàn bộ trạng thái cái app.

## Mô hình dữ liệu
- Định nghĩa ở: [lib/models.dart](lib/models.dart)
  - `TaskItem`: `id`, `title`, `category`, `deadline`, `isCompleted`.
  - `UserProfile`: `name`, `email`, `avatarSeed`.

## Quản lý trạng thái (state)
- Toàn bộ state nằm trong `_TodoAppState` (trong `lib/main.dart`):
  - `_tasks`: `List<TaskItem>` — danh sách công việc hiện tại.
  - `_categories`: `List<String>` — danh mục.
  - `_profile`: `UserProfile` — dữ liệu hồ sơ người dùng.
  - `_language`, `_themeMode`, `_tabIndex`.
- Các phương thức quan trọng:
  - `_openAddTaskPage(BuildContext)`: `Navigator.push` tới `AddTaskPage` và nhận `TaskItem` trả về; nếu có thì chèn vào `_tasks`.
  - `_toggleTask(int, bool?)`, `_deleteTask(int)` — cập nhật trạng thái task.
  - `_addCategory`, `_renameCategory`, `_deleteCategory` — thao tác lên danh mục và cập nhật task tương ứng khi cần.
  - `_updateProfile(UserProfile)` — cập nhật `_profile`.

## Điều hướng & UI chính
- Giao diện là `MaterialApp` (theme light/dark), `home` là `Scaffold` với `IndexedStack` hiển thị các trang theo `_tabIndex`.
- Các trang (trong `lib/`):
  - [lib/home_page.dart](lib/home_page.dart)
  - [lib/add_task_page.dart](lib/add_task_page.dart)
  - [lib/calendar_page.dart](lib/calendar_page.dart)
  - [lib/categories_page.dart](lib/categories_page.dart)
  - [lib/statistics_page.dart](lib/statistics_page.dart)
  - [lib/profile_page.dart](lib/profile_page.dart)
  - [lib/about_page.dart](lib/about_page.dart)
- `FloatingActionButton` chỉ hiển thị trên tab Home (mở trang Thêm công việc).

## Văn hóa dữ liệu
- Khi thêm/sửa/xóa danh mục, code đảm bảo cập nhật các `TaskItem` liên quan (ví dụ đổi category cũ sang fallback).
- Khi thêm task, app hiển thị `SnackBar` thông báo.

## Lưu trữ (Persistence)
- Hiện tại không có lưu persistent — khởi động lại app sẽ mất dữ liệu.
- Để thêm persistent, gợi ý:
  - Nhẹ: `shared_preferences` (lưu JSON nhỏ).
  - Khi cần quan hệ/phức tạp: `sqflite` hoặc `drift`.
  - Hoặc remote backend (REST/Firebase) nếu muốn đồng bộ.

## Nơi nên chỉnh đổi nhanh
- Chuỗi text / i18n: `AppStrings` trong [lib/main.dart](lib/main.dart).
- Thêm logic lưu trữ: mở `_TodoAppState` và persist `_tasks` + `_profile` khi thay đổi.
- Thêm/đổi giao diện: các file `*_page.dart` trong `lib/`.

## Chạy ứng dụng (những lệnh thường dùng)
```bash
flutter pub get
flutter run
# hoặc chạy trên Windows (nếu target windows được bật):
flutter run -d windows
```

## Gợi ý phát triển nhanh
- Muốn giữ dữ liệu giữa lần khởi động: implement serialize `TaskItem` → JSON và lưu vào `shared_preferences` khi thay đổi, load lúc `initState()`.
- Nếu muốn background notifications hoặc reminders: tích hợp `flutter_local_notifications` và lưu schedules khi tạo task.

---
Tệp này nằm ở gốc: `CACH_VAN_HANH.md` — mở để tham khảo nhanh cấu trúc và điểm điều chỉnh quan trọng.
