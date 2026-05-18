package util;

import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 * Utility class for common date and time formatting operations.
 */
public class DateUtil {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DISPLAY_DATE_FORMAT = DateTimeFormatter.ofPattern("dd MMM yyyy");
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm");
    private static final DateTimeFormatter DISPLAY_TIME_FORMAT = DateTimeFormatter.ofPattern("hh:mm a");

    /**
     * Get today's date as a string (yyyy-MM-dd).
     */
    public static String getTodayDate() {
        return LocalDate.now().format(DATE_FORMAT);
    }

    /**
     * Format a SQL Date for display (e.g. "18 May 2026").
     */
    public static String formatDate(Date date) {
        if (date == null) return "";
        return date.toLocalDate().format(DISPLAY_DATE_FORMAT);
    }

    /**
     * Format a date string (yyyy-MM-dd) for display (e.g. "18 May 2026").
     */
    public static String formatDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) return "";
        try {
            LocalDate date = LocalDate.parse(dateStr, DATE_FORMAT);
            return date.format(DISPLAY_DATE_FORMAT);
        } catch (Exception e) {
            return dateStr;
        }
    }

    /**
     * Format a SQL Time for display (e.g. "02:30 PM").
     */
    public static String formatTime(Time time) {
        if (time == null) return "";
        return time.toLocalTime().format(DISPLAY_TIME_FORMAT);
    }

    /**
     * Format a time string (HH:mm:ss) for display (e.g. "02:30 PM").
     */
    public static String formatTime(String timeStr) {
        if (timeStr == null || timeStr.isEmpty()) return "";
        try {
            LocalTime time = LocalTime.parse(timeStr);
            return time.format(DISPLAY_TIME_FORMAT);
        } catch (Exception e) {
            return timeStr;
        }
    }

    /**
     * Get the day name from a date string (e.g. "2026-05-18" -> "Sunday").
     */
    public static String getDayName(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) return "";
        try {
            LocalDate date = LocalDate.parse(dateStr, DATE_FORMAT);
            return date.getDayOfWeek().toString().charAt(0) +
                   date.getDayOfWeek().toString().substring(1).toLowerCase();
        } catch (Exception e) {
            return "";
        }
    }

    /**
     * Check if a date string is today or in the future.
     */
    public static boolean isFutureOrToday(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) return false;
        try {
            LocalDate date = LocalDate.parse(dateStr, DATE_FORMAT);
            return !date.isBefore(LocalDate.now());
        } catch (Exception e) {
            return false;
        }
    }
}
