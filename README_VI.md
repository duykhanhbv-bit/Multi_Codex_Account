# Multi_Codex_Account

*Read in English: [README.md](README.md)*

Công cụ hỗ trợ chạy nhiều tài khoản Codex CLI độc lập trên Windows.

Dự án này cung cấp 4 cấu hình (profile) Codex CLI riêng biệt với các thư mục dữ liệu (state) độc lập, giúp bạn dễ dàng đăng nhập và chuyển đổi giữa các tài khoản khác nhau chỉ bằng một cú nhấp chuột.

## Hướng dẫn sử dụng nhanh (Dùng luôn)

Để bắt đầu làm việc ngay lập tức, bạn chỉ cần thực hiện các bước sau:

1. **Tải về hoặc giải nén** thư mục này trên máy tính của bạn.
2. **Kích đúp chuột (Double-click)** vào một trong các file launcher tương ứng với tài khoản bạn muốn dùng:
   - `codex1.bat` (cho Tài khoản 1)
   - `codex2.bat` (cho Tài khoản 2)
   - `codex3.bat` (cho Tài khoản 3)
   - `codex4.bat` (cho Tài khoản 4)
3. **Nhập đường dẫn dự án một lần** khi được hỏi (ví dụ: `E:\Projects\my-app`) rồi nhấn **Enter**.
   * *Mẹo:* Nếu bạn muốn chạy Codex ngay tại thư mục hiện tại của cửa sổ terminal đang mở, bạn chỉ cần nhấn trực tiếp **Enter** mà không cần nhập gì.
4. **Đăng nhập (nếu chạy lần đầu):** Nếu tài khoản đó chưa từng đăng nhập trên máy của bạn, trình duyệt hoặc terminal sẽ hiển thị yêu cầu đăng nhập. Bạn hãy hoàn tất đăng nhập một lần duy nhất.
5. **Hoàn tất:** Trình quản lý Codex CLI sẽ tự động khởi chạy và áp dụng cấu hình riêng biệt cho tài khoản đó. Các lần chạy sau sẽ tự động nhận diện tài khoản mà không cần đăng nhập lại.

---

## Tính năng chính

- **4 tài khoản độc lập:** Từ `account-1` đến `account-4` chạy hoàn toàn song song không ảnh hưởng đến nhau.
- **Tự cô lập dữ liệu:** Mỗi tài khoản lưu trữ `CODEX_HOME`, lịch sử lệnh (history), cấu hình và thông tin đăng nhập riêng tại `state\account-N`.
- **Hỗ trợ Terminal:** Bạn có thể gọi trực tiếp lệnh `codex1`, `codex2`, `codex3`, `codex4` từ cửa sổ PowerShell/CMD khi đang đứng trong thư mục dự án để làm việc nhanh chóng.

## Yêu cầu hệ thống

- Hệ điều hành Windows.
- Máy tính đã cài đặt sẵn Codex CLI.
- Có sẵn PowerShell.

*Lưu ý: Kho lưu trữ này không đi kèm file chạy (binary) của Codex.*

## Cấu trúc dự án

- `codex1.bat` đến `codex4.bat`: Các file launcher tương tác nhanh (kích đúp để dùng).
- `open-account-1.cmd` đến `open-account-4.cmd`: Mở cửa sổ làm việc mới cho từng tài khoản cụ thể.
- `scripts\Start-CodexPortableAccount.ps1`: Script xử lý chính cho việc cấu hình và chạy tài khoản.
- `state\account-N`: Thư mục placeholder trong bản public; dữ liệu runtime của từng tài khoản sẽ được tạo ở lần chạy đầu tiên.
- `status-all-accounts.cmd`: Kiểm tra nhanh trạng thái đăng nhập của toàn bộ 4 tài khoản.

## Bảo mật

- Không chia sẻ các file cấu hình chứa thông tin đăng nhập trong thư mục `state\account-N` (như `auth.json` hay `cap_sid`) lên mạng hoặc cho người khác trừ khi đó là máy cá nhân tin cậy của bạn.

## Giấy phép (License)

Xem chi tiết tại [COPYRIGHT-NDKBVH.txt](COPYRIGHT-NDKBVH.txt).
