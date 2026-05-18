package model;

/**
 * Represents a user role.
 * Maps to the 'roles' table.
 */
public class Role {

    private int roleId;
    private String roleName;
    private String description;

    public Role() {}

    public Role(int roleId, String roleName, String description) {
        this.roleId      = roleId;
        this.roleName    = roleName;
        this.description = description;
    }

    // Getters
    public int getRoleId()           { return roleId; }
    public String getRoleName()      { return roleName; }
    public String getDescription()   { return description; }

    // Setters
    public void setRoleId(int roleId)                { this.roleId = roleId; }
    public void setRoleName(String roleName)         { this.roleName = roleName; }
    public void setDescription(String description)   { this.description = description; }
}
