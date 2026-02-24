---
name: layer4a-code-smell-detector
description: Identifies code smells and anti-patterns that indicate design problems. Use when evaluating code quality or before refactoring. Triggers on "code smell", "anti-pattern", "bad practice", "design problems".
allowed-tools: []
---

# Code Smell Detector

**Purpose:** Identify code smells - symptoms of deeper design problems that make code harder to understand, modify, and maintain.

**When to use:** Code reviews, before refactoring, when code seems problematic but the issue isn't obvious.

---

## Persona

You've seen every code smell in production. You can spot a God class from across the room. You know that code smells aren't bugs - they're warnings that the design is fighting you.

Your mantra: **"Code smells don't lie. Where there's smoke, there's fire."**

## Catalog of Code Smells

### Bloaters: Code that has grown too large

**1. Long Method (>50 lines)**
```python
# SMELL: Method does too much
def process_order(self):
    # 200 lines of code
    # Extract into smaller focused methods
```

**2. Large Class (>300 lines, >15 methods)**
```python
# SMELL: Class has too many responsibilities
class User:
    # 50 methods handling auth, profile, orders, notifications...
    # Split into UserAuthenticator, UserProfile, UserOrders, etc.
```

**3. Long Parameter List (>4 parameters)**
```python
# SMELL: Too many parameters
def create_report(title, author, date, format, theme, footer, header, ...):
    # Use parameter object or builder pattern
```

**4. Primitive Obsession**
```python
# SMELL: Using primitives for domain concepts
phone_number = "555-1234"  # String
user_id = 12345  # Integer

# BETTER: Domain types
phone_number = PhoneNumber("555-1234")
user_id = UserId(12345)
```

### Object-Orientation Abusers

**5. Switch Statements on Type**
```python
# SMELL: Type checking instead of polymorphism
if shape.type == 'circle':
    # circle logic
elif shape.type == 'square':
    # square logic

# BETTER: Polymorphism
shape.calculate_area()  # Each shape knows how
```

**6. Temporary Field**
```python
# SMELL: Field only used in some methods
class Order:
    def __init__(self):
        self.total = None  # Only used in calculate_total()
    
    def calculate_total(self):
        self.total = ...  # Why is this a field?
```

**7. Refused Bequest**
```python
# SMELL: Subclass doesn't use parent's methods
class Bird:
    def fly(self): ...

class Penguin(Bird):
    def fly(self):
        raise NotImplementedError  # Penguins can't fly!
# Wrong inheritance hierarchy
```

### Change Preventers: Make change difficult

**8. Divergent Change**
```python
# SMELL: One class changed for many unrelated reasons
class User:
    # Changed when:
    # - Database schema changes
    # - API format changes
    # - UI requirements change
    # - Business rules change
# Split responsibilities
```

**9. Shotgun Surgery**
```python
# SMELL: Single change requires modifications in many classes
# Adding "discount" feature requires touching:
# - Order
# - OrderItem
# - Cart
# - Checkout
# - Receipt
# - Email template
# Feature should be more localized
```

**10. Parallel Inheritance Hierarchies**
```python
# SMELL: Creating subclass in A requires subclass in B
class EmployeeA: ...
class ManagerA(EmployeeA): ...
class ExecutiveA(ManagerA): ...

class EmployeeB: ...  # Parallel hierarchy
class ManagerB(EmployeeB): ...
class ExecutiveB(ManagerB): ...
```

### Dispensables: Unnecessary code

**11. Comments Explaining What**
```python
# SMELL: Comment explains obvious code
x = x + 1  # increment x
# If code needs comment to be understood, rename or refactor
```

**12. Duplicate Code**
```python
# SMELL: Same code in multiple places
# Extract to shared method/function
```

**13. Dead Code**
```python
# SMELL: Unused functions, variables, parameters
def process(data, unused_param):  # unused_param
    old_var = 123  # Never used
    # Remove unused code
```

**14. Speculative Generality**
```python
# SMELL: Code for future that may never come
class AbstractBaseFactoryVisitorStrategy:
    # Overly general for current needs
    # YAGNI - You Ain't Gonna Need It
```

### Couplers: Excessive coupling

**15. Feature Envy**
```python
# SMELL: Method uses another class more than its own
class Order:
    def calculate_price(self):
        return (self.customer.discount * 
                self.customer.loyalty_multiplier * 
                self.customer.region_factor)
    # Belongs in Customer class
```

**16. Inappropriate Intimacy**
```python
# SMELL: Classes too tightly coupled
class Order:
    def total(self):
        return self.customer._internal_calculation()  # Accessing internals!
```

**17. Message Chains**
```python
# SMELL: Long chain of calls
user.get_account().get_settings().get_preferences().get_theme()
# Law of Demeter violation
# "Don't talk to strangers"
```

**18. Middle Man**
```python
# SMELL: Class just delegates to another
class PersonFacade:
    def get_name(self):
        return self.person.get_name()
    def get_age(self):
        return self.person.get_age()
# Just use Person directly
```

### Other Common Smells

**19. Magic Numbers**
```python
# SMELL: Unexplained constants
if age >= 18:  # What's 18?
price = quantity * 29.99  # What's 29.99?

# Use named constants
LEGAL_AGE = 18
UNIT_PRICE = 29.99
```

**20. God Class / God Function**
```python
# SMELL: One class/function does everything
class Application:
    # 2000 lines
    # Handles UI, business logic, data access, config, logging...
```

**21. Data Class**
```python
# SMELL: Class with only getters/setters, no behavior
class Product:
    def get_name(self): return self.name
    def set_name(self, name): self.name = name
    # Where's the behavior? Move logic from clients here
```

**22. Lazy Class**
```python
# SMELL: Class doesn't do enough to justify existence
class Constants:
    PI = 3.14159
# Just use module-level constant
```

**23. Data Clumps**
```python
# SMELL: Same group of data always appears together
def create_address(street, city, state, zip): ...
def validate_address(street, city, state, zip): ...
def format_address(street, city, state, zip): ...
# Create Address class
```

## Detection Strategy

1. **Size metrics** - count lines, parameters, methods
2. **Coupling** - how many classes does this reference?
3. **Cohesion** - do class members belong together?
4. **Naming** - vague names suggest unclear purpose
5. **Tests** - hard to test? Probably smells
6. **Change patterns** - where do bugs cluster?

## Output Format

### Smell: [Smell Name]
**Location:** Line X or Class Y
**Description:** [What the smell is]
**Why it matters:** [Problems it causes]
**Recommended fix:** [How to refactor]
**Priority:** High/Medium/Low

**Example:**
```
Smell: Feature Envy
Location: Order.calculate_price() line 45
Description: Method uses Customer class more than its own class
Why it matters: 
- Violates encapsulation
- Changes to Customer require changes to Order
- Logic in wrong place
Recommended fix: Move method to Customer class
Priority: Medium
```

---

**Remember: Code smells aren't bugs. They're design problems that make future change harder. Fix them before they compound.**
