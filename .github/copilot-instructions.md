# Copilot Instructions for CBValidation

## Project Overview

CBValidation is a server-side validation engine for ColdBox applications providing unified object, struct, and form validation. The module implements a comprehensive validator pattern with extensible constraint rules, localization support via cbi18n, and deep integration with ColdBox's WireBox dependency injection container.

## Architecture & Core Components

### Validation Engine Architecture
- **ValidationManager** (`models/ValidationManager.cfc`): Central orchestrator handling constraint discovery, rule processing, and validator delegation
- **Validators** (`models/validators/`): Individual constraint validators extending BaseValidator with specific validation logic
- **ValidationResult** (`models/result/ValidationResult.cfc`): Immutable result container with error aggregation and i18n message formatting
- **GenericObject** (`models/GenericObject.cfc`): Wrapper for validating simple structures/forms as objects

### Constraint System Patterns
```javascript
// Object-based constraints (preferred approach)
component {
    this.constraints = {
        email: { required: true, type: "email" },
        age: { required: true, min: 18, max: 65 }
    };
    
    // Profile-based field selection for targeted validation
    this.constraintProfiles = {
        registration: "email,password,confirmPassword",
        update: "email,firstName,lastName"  
    };
}

// Shared constraints via module settings (global reuse)
moduleSettings = {
    cbValidation = {
        sharedConstraints = {
            userRegistration = {
                email: { required: true, type: "email" }
            }
        }
    }
};
```

### Validator Discovery & Extension
- **Auto-Discovery**: ValidationManager scans `models/validators/` and builds wirebox mapping for `*Validator.cfc` files
- **Validator Aliases**: `items` → `arrayItem`, `constraints` → `nestedConstraints` for shorthand usage
- **Custom Validators**: Implement IValidator interface, register via `validator: "path.to.CustomValidator"` or wirebox ID

## Key Implementation Patterns

### Validation Workflow
1. **Constraint Resolution**: `determineConstraintsDefinition()` - object properties → shared constraints → inline structs
2. **Profile Processing**: Constraint profiles expand to `includeFields` for targeted validation scenarios  
3. **Rule Processing**: `processRules()` iterates constraints, delegating to specific validators
4. **Result Aggregation**: ValidationResult accumulates errors with i18n message formatting

### Mixin Integration Pattern
The module injects validation methods globally via `helpers/Mixins.cfm`:
```javascript
// In any ColdBox component (handlers, views, layouts, interceptors)
var result = validate(target=user, constraints="userValidation");
if (result.hasErrors()) {
    // Handle validation errors
}

// Throws ValidationException on failure with JSON error details
var validUser = validateOrFail(target=user, profiles="registration");
```

### Advanced Constraint Features
```javascript
// Nested object validation with dot notation
this.constraints = {
    "address.street": { required: true, size: "5..100" },
    "preferences.*": { type: "string" }  // Array item validation
};

// Conditional validation
email: {
    requiredIf: { userType: "premium" },
    requiredUnless: { authProvider: "oauth" }
}

// Custom validation methods
password: { 
    method: "validatePasswordStrength",  // Call this.validatePasswordStrength()
    udf: variables.customValidator       // Direct function reference
}
```

## Developer Workflows

### Testing Strategy
- **Test Harness**: Full ColdBox application in `test-harness/` for integration testing
- **Unit Tests**: `test-harness/tests/specs/` - focus on ValidationManager and individual validators
- **Test Execution**: `box testbox run` from module root, leverages test-harness Application.cfc

### Build & Release Process
- **Build Script**: `build/Build.cfc` handles testing, docs generation, and packaging
- **Commands**: `box task run build/Build.cfc` for full build pipeline
- **API Docs**: Generated for `models/` directory only (public API surface)

### Development Environment Setup
```bash
# Install dependencies and start development
box install
box server start serverConfigFile=server-lucee@5.json

# Run tests during development  
box testbox run

# Format code to standards
box run-script format

# Build and package module
box task run build/Build.cfc
```

## Dependency Integration

### CBi18n Integration (Required Dependency)
- **Message Localization**: ValidationResult uses ResourceService for translating error messages
- **Constraint Messages**: Support `{propertyName}Message` keys for field-specific i18n overrides
- **Locale Support**: Validation methods accept `locale` parameter for multilingual applications

### WireBox Registration Patterns
```javascript
// Module auto-registers core services
"ValidationManager@cbvalidation"  // Primary validation engine
"validationManager@cbvalidation"  // Alias for convenience

// Custom validation manager override
moduleSettings = {
    cbValidation = {
        manager: "path.to.CustomValidationManager"  // Replace default engine
    }
};
```

## Integration Examples

### Form Validation in Handlers
```javascript
function saveUser(event, rc, prc) {
    var result = validate(target=rc, constraints="userRegistration");
    if (result.hasErrors()) {
        prc.errors = result.getAllErrors();
        return event.setView("users/registration");
    }
    // Process valid data
}
```

### API Validation with Exception Handling
```javascript
function apiCreateUser(event, rc, prc) {
    try {
        var validData = validateOrFail(target=rc, profiles="api");
        var user = userService.create(validData);
        return event.renderData(data=user);
    } catch(ValidationException e) {
        return event.renderData(
            statusCode=422, 
            data={errors: deserializeJSON(e.extendedInfo)}
        );
    }
}
```

## Common Conventions

### Constraint Naming
- Use descriptive field names matching object properties exactly
- Leverage profiles for context-specific validation (registration, update, etc.)
- Group related constraints in shared constraint structures for reuse

### Error Handling Patterns
- Prefer `validate()` for form scenarios where you display errors inline
- Use `validateOrFail()` for API endpoints requiring immediate exception handling
- Always check `result.hasErrors()` before proceeding with business logic

### Testing Validators
- Extend `coldbox.system.testing.BaseTestCase` for integration tests
- Mock ValidationResult for unit testing individual validators  
- Test constraint edge cases: null values, empty strings, boundary conditions