package dao;

import java.time.LocalTime;
import java.util.*;

public class SlotGenerator {

    public static List<String> generateSlots(LocalTime start, LocalTime end, int minutes) {

        List<String> slots = new ArrayList<>();
        LocalTime current = start;

        while (current.plusMinutes(minutes).isBefore(end) ||
               current.plusMinutes(minutes).equals(end)) {

            LocalTime next = current.plusMinutes(minutes);
            slots.add(current + " - " + next);
            current = next;
        }

        return slots;
    }
}