package util;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class SlotGenerator {

    // Generate all possible time slots between start and end
    // based on slot duration in minutes
    // e.g. start=09:00, end=17:00, duration=30
    // returns ["09:00", "09:30", "10:00" ... "16:30"]
    public static List<String> generateSlots(String startTime,
                                              String endTime,
                                              int slotDurationMinutes) {
        List<String> slots = new ArrayList<>();

        LocalTime current = LocalTime.parse(startTime);
        LocalTime end     = LocalTime.parse(endTime);

        while (!current.plusMinutes(slotDurationMinutes).isAfter(end)) {
            // Format as "HH:mm" always — e.g. "09:00" not "9:00"
            slots.add(String.format("%02d:%02d",
                      current.getHour(),
                      current.getMinute()));
            current = current.plusMinutes(slotDurationMinutes);
        }

        return slots;
    }

    // Get the day name from a date string
    // e.g. "2026-05-12" -> "Tuesday"
    public static String getDayName(String date) {
        try {
            LocalDate localDate = LocalDate.parse(date);
            return localDate.getDayOfWeek()
                            .getDisplayName(TextStyle.FULL, Locale.ENGLISH);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    // Check if a given date is in the past
    // Used to prevent booking past dates
    public static boolean isPastDate(String date) {
        try {
            LocalDate selected = LocalDate.parse(date);
            return selected.isBefore(LocalDate.now());
        } catch (Exception e) {
            return true;
        }
    }

    // Check if a slot time is valid format HH:mm
    public static boolean isValidTime(String time) {
        try {
            LocalTime.parse(time);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}