# Báo cáo xử lý sự cố Pipeline CI/CD (Session 12 - Bài 5)

## 1. Sự cố 1: Gradle Wrapper Permission Denied

- **Hiện tượng:** Bước chạy kiểm thử Java thất bại với thông báo log: `/bin/sh: 1: ./gradlew: Permission denied`.
- **Nguyên nhân:** File wrapper `gradlew` không có cờ thực thi `+x` khi runner checkout code.
- **Giải pháp:** Bổ sung step `run: chmod +x gradlew` ngay trước khi thực thi lệnh `./gradlew test`.
- **Kết quả:** Runner thực thi script thành công, test suite vượt qua (PASS).

## 2. Sự cố 2: Docker Registry Authentication Failed

- **Hiện tượng:** Step đăng nhập Docker Registry báo lỗi `Error: Username and password are required` hoặc
  `unauthorized: incorrect username or password`.
- **Nguyên nhân:** Tên secret trong file workflow bị sai chính tả hoặc lệch tên so với GitHub Actions Secrets (
  `${{ secrets.REGISTRY_TOKEN }}`).
- **Giải pháp:** Kiểm tra mục Settings > Secrets & Variables của Repository, đồng bộ lại key
  `${{ secrets.REGISTRY_TOKEN }}` trong step `docker/login-action`.
- **Kết quả:** Đăng nhập thành công với log hiển thị `Login Succeeded`.

## 3. Sự cố 3: Docker Build Context Error

- **Hiện tượng:** Step build image báo lỗi
  `failed to solve: failed to read dockerfile: open /var/lib/docker/.../Dockerfile: no such file or directory`.
- **Nguyên nhân:** Tham số `context` và `file` cấu hình sai hoặc thiếu đường dẫn tương đối trỏ về thư mục chứa
  Dockerfile.
- **Giải pháp:** Chỉ định rõ:
    - `context: .`
    - `file: ./Dockerfile`
- **Kết quả:** Docker Buildx nhận đúng ngữ cảnh, đóng gói image và đẩy lên Docker Hub thành công.