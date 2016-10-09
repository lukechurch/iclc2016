"use strict";

class ASTNode {
    toJSONStringRecursive() { return ""; };
}

class Program extends ASTNode {
    constructor(statements) {
        super();
        this.statements = statements;
    }

    toJSONStringRecursive() {
        var jsonString = "{\"program\": {\"statements\": [";
        for (var i in this.statements) {
            jsonString = jsonString + this.statements[i].toJSONStringRecursive() + ",";
        }
        if (jsonString.slice(-1) === ",") {
            jsonString = jsonString.slice(0, -1); // remove last comma
        }
        jsonString = jsonString + "]}}";
        return jsonString;
    }
}

class Statement extends ASTNode {
    constructor() {
        super();
    }
}

class VariableDeclaration extends Statement {
    constructor(identifier, expression) {
        super();
        this.identifier = identifier;
        this.expression = expression;
    }
    toJSONStringRecursive() {
        var jsonString =
                "{\"variableDeclaration\": {" +
                        "\"identifier\": " + this.identifier.toJSONStringRecursive() + "," +
                        "\"value\": " + this.expression.toJSONStringRecursive() +
                "}}";
        return jsonString;
    }
}

class VariableAssignment extends Statement {
    constructor(identifier, expression) {
        super();
        this.identifier = identifier;
        this.expression = expression;
    }
    toJSONStringRecursive() {
        var jsonString =
                "{\"variableAssignment\": {" +
                        "\"identifier\": " + this.identifier.toJSONStringRecursive() + "," +
                        "\"value\": " + this.expression.toJSONStringRecursive() +
                "}}";
        return jsonString;
    }
}

class WhileLoop extends Statement {
    constructor(condition, statements) {
        super();
        this.condition = condition;
        this.statements = statements;
    }

    toJSONStringRecursive() {
        var jsonString =
                "{\"whileLoop\": {" +
                        "\"condition\": " + this.condition.toJSONStringRecursive() + "," +
                        "\"statements\": [";
        for (var i in this.statements) {
             jsonString = jsonString + this.statements[i].toJSONStringRecursive() + ",";
        }
        if (jsonString.slice(-1) === ",") {
            jsonString = jsonString.slice(0, -1); // remove last comma
        }
        jsonString = jsonString + "]}}";
        return jsonString;
    }
}

class Expression extends ASTNode {
    constructor() {
        super();
    }
}

class BinaryOperation extends Expression {
    constructor(operation, lhs, rhs) {
        super();
        this.operation = operation;
        this.lhs = lhs;
        this.rhs = rhs;
    }

    toJSONStringRecursive() {
        var jsonString =
                "{\"binaryOperation\": {" +
                        "\"operation\": \"" + this.operation + "\"," +
                        "\"lhs\": " + this.lhs.toJSONStringRecursive() + "," +
                        "\"rhs\": " + this.rhs.toJSONStringRecursive() +
                "}}";
        return jsonString;
    }
}

class UnaryOperation extends Expression {
    constructor(operation, operand) {
        super();
        this.operation = operation;
        this.operand = operand;
    }

    toJSONStringRecursive() {
        var jsonString =
                "{\"unaryOperation\": {" +
                        "\"operation\": \"" + this.operation + "\"," +
                        "\"operand\": " + this.operand.toJSONStringRecursive() +
                "}}";
        return jsonString;
    }
}

class Call extends Expression {
    constructor(receiver, args) {
        super();
        this.receiver = receiver;
        this.args = args;
    }

    toJSONStringRecursive() {
        var jsonString =
                "{\"call\": {" +
                        "\"receiver\": " + this.receiver.toJSONStringRecursive() + "," +
                        "\"args\": [";
        for (var i in this.args) {
            jsonString = jsonString + this.args[i].toJSONStringRecursive() + ",";
        }
        if (jsonString.slice(-1) === ",") {
            jsonString = jsonString.slice(0, -1); // remove last comma
        }
        jsonString = jsonString + "]}}";
        return jsonString;
    }
}

class Var extends Expression {
    constructor(name) {
        super();
        this.name = name; // JS string
    }

    toJSONStringRecursive() {
        var jsonString = "{\"variable\": \"" + this.name + "\"}";
        return jsonString;
    }
}

class Integer extends Expression {
    constructor(value) {
        super();
        this.value = value; // JS int
    }

    toJSONStringRecursive() {
        var jsonString = "{\"int\": " + this.value + "}";
        return jsonString;
    }
}

class Float extends Expression {
    constructor(value) {
        super();
        this.value = value; // JS float
    }

    toJSONStringRecursive() {
        var jsonString = "{\"float\": " + this.value + "}";
        return jsonString;
    }
}

class Boolean extends Expression {
    constructor(value) {
        super();
        this.value = value; // JS bool
    }

    toJSONStringRecursive() {
        var jsonString = "{\"boolean\": \"" + this.value + "\"}";
        return jsonString;
    }
}

class String extends Expression {
    constructor(value) {
        super();
        this.value = value; // JS string
    }

    toJSONStringRecursive() {
        var jsonString = "{\"string\": \"" + this.value + "\"}";
        return jsonString;
    }
}

module.exports = {
    Program: Program,
    Statement: Statement,
    VariableDeclaration: VariableDeclaration,
    VariableAssignment: VariableAssignment,
    WhileLoop: WhileLoop,
    Expression: Expression,
    BinaryOperation: BinaryOperation,
    UnaryOperation: UnaryOperation,
    Call: Call,
    Var: Var,
    Integer: Integer,
    Float: Float,
    Boolean: Boolean,
    String: String,
};
