package com.slotsync.test;

import com.slotsync.dao.SearchDAO;
import com.slotsync.dao.ServiceDAO;
import com.slotsync.dao.StatsDAO;
import com.slotsync.model.Service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Run this as a plain Java main class (right-click → Run in IntelliJ/Antigravity).
 * Make sure DBConnection.java has your MySQL password before running.
 */
public class IntegrationTest {

    static ServiceDAO serviceDAO = new ServiceDAO();
    static SearchDAO  searchDAO  = new SearchDAO();
    static StatsDAO   statsDAO   = new StatsDAO();
    static int passed = 0;
    static int failed = 0;

    public static void main(String[] args) {
        System.out.println("===========================================");
        System.out.println("  SlotSync Integration Tests");
        System.out.println("===========================================\n");

        test1_getAllServices();
        test2_getServiceById();
        test3_addService();
        test4_updateService();
        test5_deleteService();
        test6_searchServices();
        test7_searchUsers();
        test8_searchBusinesses();
        test9_filterByEmployee();
        test10_stats();

        System.out.println("\n===========================================");
        System.out.println("  PASSED: " + passed + " | FAILED: " + failed);
        System.out.println("===========================================");
    }

    static void test1_getAllServices() {
        print("[TEST 1] getAllServices()");
        try {
            List<Service> list = serviceDAO.getAllServices();
            pass("Found " + list.size() + " services");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test2_getServiceById() {
        print("[TEST 2] getServiceById(1)");
        try {
            Service s = serviceDAO.getServiceById(1);
            if (s != null) pass("Found: " + s.getServiceName());
            else fail("No service with ID 1 found");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test3_addService() {
        print("[TEST 3] addService()");
        try {
            Service s = new Service();
            s.setBusinessId(1);
            s.setServiceName("TEST_" + System.currentTimeMillis());
            s.setCategoryId(1);
            s.setDurationMin(30);
            s.setPrice(100.00);
            s.setDescription("Integration test - safe to delete");
            s.setActive(true);
            boolean ok = serviceDAO.addService(s);
            if (ok) pass("Service inserted");
            else fail("Insert returned false");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test4_updateService() {
        print("[TEST 4] updateService(1)");
        try {
            Service s = serviceDAO.getServiceById(1);
            if (s == null) { fail("Service 1 not found"); return; }
            String original = s.getServiceName();
            s.setServiceName(original + "_updated");
            serviceDAO.updateService(s);
            s.setServiceName(original);
            serviceDAO.updateService(s); // restore
            pass("Update and restore successful");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test5_deleteService() {
        print("[TEST 5] deleteService() - deletes test service from test3");
        try {
            List<Service> all = serviceDAO.getAllServices();
            Service toDelete = null;
            for (int i = all.size() - 1; i >= 0; i--) {
                if (all.get(i).getServiceName().startsWith("TEST_")) {
                    toDelete = all.get(i);
                    break;
                }
            }
            if (toDelete == null) { fail("Test service not found"); return; }
            boolean ok = serviceDAO.deleteService(toDelete.getServiceId());
            if (ok) pass("Deleted service ID " + toDelete.getServiceId());
            else fail("Delete returned false");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test6_searchServices() {
        print("[TEST 6] searchServices('hair')");
        try {
            List<Service> results = searchDAO.searchServices("hair");
            pass("Returned " + results.size() + " result(s)");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test7_searchUsers() {
        print("[TEST 7] searchUsers('admin')");
        try {
            List<Map<String, String>> results = searchDAO.searchUsers("admin");
            pass("Returned " + results.size() + " user(s)");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test8_searchBusinesses() {
        print("[TEST 8] searchBusinesses('salon')");
        try {
            List<Map<String, String>> results = searchDAO.searchBusinesses("salon");
            pass("Returned " + results.size() + " business(es)");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test9_filterByEmployee() {
        print("[TEST 9] filterByEmployee(1)");
        try {
            List<Service> results = searchDAO.filterByEmployee(1);
            pass("Returned " + results.size() + " service(s) for employee 1");
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void test10_stats() {
        print("[TEST 10] StatsDAO - all methods");
        try {
            int    total    = statsDAO.getTotalAppointments();
            int    done     = statsDAO.getCompletedAppointments();
            int    users    = statsDAO.getTotalActiveUsers();
            double revenue  = statsDAO.getTotalRevenue();
            List<?> popular = statsDAO.getPopularServices();
            List<?> emps    = statsDAO.getTopEmployees();
            List<?> status  = statsDAO.getAppointmentsByStatus();
            List<?> ratings = statsDAO.getAverageRatings();
            pass("Appointments=" + total + " Completed=" + done + " Users=" + users + " Revenue=" + revenue);
        } catch (SQLException e) { fail(e.getMessage()); }
    }

    static void print(String label) { System.out.print(label + " ... "); }
    static void pass(String msg)    { System.out.println("PASS ✓  " + msg); passed++; }
    static void fail(String msg)    { System.out.println("FAIL ✗  " + msg); failed++; }
}
