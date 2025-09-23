Add an item to your todolist for tracking tasks during the current session.

**Implementation:**
When this command is invoked, use the `todowrite` tool to add the specified item to the todolist with:
- Status: `pending`
- Priority: `medium` (default)
- Content: The provided text after `/todo `

**Example:**
```
User: /todo Add unit tests for payment module
Assistant: [Uses todowrite tool to add "Add unit tests for payment module" with status "pending" and priority "medium"]
Added "Add unit tests for payment module" to todolist.
```
