package util;

import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Utility class for session management operations.
 */
public class SessionUtil {

    /**
     * Get the logged-in User object from the session.
     */
    public static User getLoggedInUser(HttpSession session) {
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }

    /**
     * Get the user ID from the session.
     */
    public static int getUserId(HttpSession session) {
        User user = getLoggedInUser(session);
        return (user != null) ? user.getUserId() : -1;
    }

    /**
     * Get the role name from the session.
     */
    public static String getRole(HttpSession session) {
        if (session == null) return null;
        return (String) session.getAttribute("role");
    }

    /**
     * Check if a user is currently logged in.
     */
    public static boolean isLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("user") != null;
    }

    /**
     * Check if the logged-in user has a specific role.
     */
    public static boolean hasRole(HttpSession session, String role) {
        String currentRole = getRole(session);
        return role != null && role.equals(currentRole);
    }

    /**
     * Invalidate the session (logout).
     */
    public static void logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }
}
