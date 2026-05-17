package util;

public class ValidationUtil {

    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    public static boolean isValidPassword(String password) {
        // at least 6 characters
        return password != null && password.length() >= 6;
    }

    public static boolean isValidName(String name) {
        return name != null && name.matches("^[A-Za-z ]+$");
    }
}