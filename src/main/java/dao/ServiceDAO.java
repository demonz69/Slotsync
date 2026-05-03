package dao;

import model.Service;
import java.util.*;

public class ServiceDAO {
    private List<Service> list = new ArrayList<>();

    public void addService(Service s) { list.add(s); }

    public List<Service> getAll() { return list; }

    public void delete(int id) {
        list.removeIf(s -> s.getId() == id);
    }
}