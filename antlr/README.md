# ANTLR
ANTLR supports a number of different targets. See [Github](https://github.com/antlr/antlr4) for more details.

There are many examples of grammars in the [grammars-v4 Github repository](https://github.com/antlr/grammars-v4).

To create a non-Java target, do like so:
```
$ antlr4 -Dlanguage=TARGET MyGrammar.g4
```

where *TARGET* is one of `Cpp`, `JavaScript`, `Dart`, `TypeScript`, `Go`, 

## Java

### Intellij

There is a very complete and useful plug-in for intellij 12-14, you can grab at the [download page](https://plugins.jetbrains.com/plugin/7358?pr=). Check the [plugin readme](https://github.com/antlr/intellij-plugin-v4) for feature set. Just go to the preferences and click on the "Install plug-in from disk..." button from this dialog box:

### Eclipse

Edgar Espina has created an [eclipse plugin for ANTLR v4](https://marketplace.eclipse.org/content/antlr-ide). Features: Advanced Syntax Highlighting, Automatic Code Generation (on save), Manual Code Generation (through External Tools menu), Code Formatter (Ctrl+Shift+F), Syntax Diagrams, Advanced Rule Navigation between files (F3), Quick fixes.

### NetBeans

Sam Harwell's [ANTLRWorks2](http://tunnelvisionlabs.com/products/demo/antlrworks) works also as a plug-in, not just a stand-alone tool built on top of NetBeans.

### Gradle


## C# `-Dlanguage=CSharp`
You will find full instructions on the [Git repo page for ANTLR C# runtime](https://github.com/antlr/antlr4/tree/master/runtime/CSharp).
 
### How do I use the runtime from my project?

(i.e., How do I run the generated lexer and/or parser?)

Let's suppose that your grammar is named `MyGrammar`. The tool will generate for you the following files:

*   MyGrammarLexer.cs
*   MyGrammarParser.cs
*   MyGrammarListener.cs (if you have not activated the -no-listener option)
*   MyGrammarBaseListener.cs (if you have not activated the -no-listener option)
*   MyGrammarVisitor.cs (if you have activated the -visitor option)
*   MyGrammarBaseVisitor.cs (if you have activated the -visitor option)

Now a fully functioning code might look like the following for start rule `StartRule`:

```csharp
using Antlr4.Runtime;
using Antlr4.Runtime.Tree;
     
public void MyParseMethod() {
      String input = "your text to parse here";
      ICharStream stream = CharStreams.fromString(input);
      ITokenSource lexer = new MyGrammarLexer(stream);
      ITokenStream tokens = new CommonTokenStream(lexer);
      MyGrammarParser parser = new MyGrammarParser(tokens);
      IParseTree tree = parser.StartRule();
}
```

This program will work. But it won't be useful unless you do one of the following:

* you visit the parse tree using a custom listener
* you visit the parse tree using a custom visitor
* your grammar comprises production code (like AntLR3)

(please note that production code is target specific, so you can't have multi target grammars that include production code)
 
### How do I create and run a custom listener?

Let's suppose your MyGrammar grammar comprises 2 rules: "key" and "value".

The antlr4 tool will have generated the following listener (only partial code shown here): 

```csharp
interface IMyGrammarParserListener : IParseTreeListener {
      void EnterKey (MyGrammarParser.KeyContext context);
      void ExitKey (MyGrammarParser.KeyContext context);
      void EnterValue (MyGrammarParser.ValueContext context);
      void ExitValue (MyGrammarParser.ValueContext context);
}
```
 
In order to provide custom behavior, you might want to create the following class:
 
```csharp
class KeyPrinter : MyGrammarBaseListener {
    // override default listener behavior
    void ExitKey (MyGrammarParser.KeyContext context) {
        Console.WriteLine("Oh, a key!");
    }
}
```
   
In order to execute this listener, you would simply add the following lines to the above code:
 
 
```csharp
...
IParseTree tree = parser.StartRule() - only repeated here for reference
KeyPrinter printer = new KeyPrinter();
ParseTreeWalker.Default.Walk(printer, tree);
```
        
Further information can be found from The Definitive ANTLR Reference book.

The C# implementation of ANTLR is as close as possible to the Java one, so you shouldn't find it difficult to adapt the examples for C#. See also [Sam Harwell's alternative C# target](https://github.com/tunnelvisionlabs/antlr4cs)

## Python 3 `-Dlanguage=Python`

You will need to install Python and Pip, version 3.6 or better.

See https://www.python.org/downloads/ and https://www.geeksforgeeks.org/how-to-install-pip-on-windows/.

### A simple example targeting Python3

An example of a parser for the Python3 target consists of the following files.
* An Antlr4 grammar, e.g., Expr.g4:
    ```antlr
    grammar Expr;
    start_ : expr (';' expr)* EOF;
    expr : atom | ('+' | '-') expr | expr '**' expr | expr ('*' | '/') expr | expr ('+' | '-') expr | '(' expr ')' | atom ;
    atom : INT ;
    INT : [0-9]+ ;
    WS : [ \t\n\r]+ -> skip ;
    ```
* Driver.py:
The driver code opens a file, creates a lexer, token stream,
and parser, then calls the parser.
    ```python
    import sys
    from antlr4 import *
    from ExprLexer import ExprLexer
    from ExprParser import ExprParser
    from VisitorInterp import VisitorInterp

    def main(argv):
        input_stream = FileStream(argv[1])
        lexer = ExprLexer(input_stream)
        stream = CommonTokenStream(lexer)
        parser = ExprParser(stream)
        tree = parser.start_()

    if __name__ == '__main__':
        main(sys.argv)
    ```
* requirements.txt:
This file contains a list of the required packages for the program. Required packages are downloaded by `pip`. The file must include a reference to the Antlr Python3 runtime.
    ```
    antlr4-python3-runtime==4.13.0
    ```
* A build script, e.g., build.sh: You should provide a script that builds the program.
    ```
    pip install -r requirements.txt
    antlr4 -Dlanguage=Python3 Expr.g4
    ```
_It is vital that the versions for the Antlr tool used to generate the parser and the Antlr Python3 runtime match. E.g., 4.13.0. Using build files will help eliminate common errors from happening._

_For a list of antlr4 tool options, please visit [ANTLR Tool Command Line Options](https://github.com/antlr/antlr4/blob/master/doc/tool-options.md)._
* Input, e.g., input.txt:
    ```
    -(1 + 2)/3;
    1;
    2+3;
    8*9
    ```
* A run script, which runs your program.
    ```
    python Driver.py input.txt
    ```

### Parse tree traversal

Tree traversal is used to implement [static](https://en.wikipedia.org/wiki/Static_program_analysis) or [dynamic](https://en.wikipedia.org/wiki/Dynamic_program_analysis) program analysis. Antlr generates two types of tree traversals: visitors and listeners.

Understanding when to choose a visitor versus a listener is a good idea. For further information, see https://tomassetti.me/listeners-and-visitors/.

A visitor is the best choice when computing only a single [synthesized attribute](https://en.wikipedia.org/wiki/Attribute_grammar#Synthesized_attributes) or when you want to control the order of parse tree nodes visited. Alternatively, a listener is the best choice when computing both synthesized and [inherited attributes](https://en.wikipedia.org/wiki/Attribute_grammar#Inherited_attributes).

In many situations, they are interchangeable.

### Visitors

Antlr visitors generally implement a post-order tree walk. If you write `visit...` methods, the method must contain code to visit the children in the order you want. For a post-order tree walk, visit the children first.

To implement a visitor, add the `-visitor` option to the `antlr4` command. Create a class that inherits from the generated visitor, then add `visit` methods that implement the analysis. Your driver code should call the `visit()` method for the root of the parse tree.

For example, the following code implements an expression evaluator for the Expr.g4 grammar using a visitor.

* Driver.py:
    ```python
    import sys
    from antlr4 import *
    from ExprLexer import ExprLexer
    from ExprParser import ExprParser
    from VisitorInterp import VisitorInterp

    def main(argv):
        input_stream = FileStream(argv[1])
        lexer = ExprLexer(input_stream)
        stream = CommonTokenStream(lexer)
        parser = ExprParser(stream)
        tree = parser.start_()
        if parser.getNumberOfSyntaxErrors() > 0:
            print("syntax errors")
        else:
            vinterp = VisitorInterp()
            vinterp.visit(tree)

    if __name__ == '__main__':
        main(sys.argv)
    ```
* VisitorInterp.py:
    ```python
    import sys
    from antlr4 import *
    from ExprParser import ExprParser
    from ExprVisitor import ExprVisitor

    class VisitorInterp(ExprVisitor):
        def visitAtom(self, ctx:ExprParser.AtomContext):
            return int(ctx.getText())

        def visitExpr(self, ctx:ExprParser.ExprContext):
            if ctx.getChildCount() == 3:
                if ctx.getChild(0).getText() == "(":
                    return self.visit(ctx.getChild(1))
                op = ctx.getChild(1).getText()
                v1 = self.visit(ctx.getChild(0))
                v2 = self.visit(ctx.getChild(2))
                if op == "+":
                    return v1 + v2
                if op == "-":
                    return v1 - v2
                if op == "*":
                    return v1 * v2
                if op == "/":
                    return v1 / v2
                return 0
            if ctx.getChildCount() == 2:
                opc = ctx.getChild(0).getText()
                if opc == "+":
                    return self.visit(ctx.getChild(1))
                if opc == "-":
                    return - self.visit(ctx.getChild(1))
                return 0
            if ctx.getChildCount() == 1:
                return self.visit(ctx.getChild(0))
            return 0

        def visitStart_(self, ctx:ExprParser.Start_Context):
            for i in range(0, ctx.getChildCount(), 2):
                print(self.visit(ctx.getChild(i)))
            return 0
    ```

### Listeners

Antlr listeners perform an LR tree traversal. `enter` and `exit` methods are called during the tranversal. A parse tree node is visited twice, first for the `enter` method, then the `exit` method after all children have been walked.

To implement a listener, add the `-listener` option to the `antlr4` command. Add a class that inherits from the generated listener
with code that implements the analysis.

The following example implements an expression evaluator using a listener.

* Driver.py:
    ```python
    import sys
    from antlr4 import *
    from ExprLexer import ExprLexer
    from ExprParser import ExprParser
    from ListenerInterp import ListenerInterp

    def main(argv):
        input_stream = FileStream(argv[1])
        lexer = ExprLexer(input_stream)
        stream = CommonTokenStream(lexer)
        parser = ExprParser(stream)
        tree = parser.start_()
        if parser.getNumberOfSyntaxErrors() > 0:
            print("syntax errors")
        else:
            linterp = ListenerInterp()
            walker = ParseTreeWalker()
            walker.walk(linterp, tree)

    if __name__ == '__main__':
        main(sys.argv)
    ```
    * ListenerInterp.py:
    ```python
    import sys
    from antlr4 import *
    from ExprParser import ExprParser
    from ExprListener import ExprListener

    class ListenerInterp(ExprListener):
        def __init__(self):
            self.result = {}

        def exitAtom(self, ctx:ExprParser.AtomContext):
            self.result[ctx] = int(ctx.getText())

        def exitExpr(self, ctx:ExprParser.ExprContext):
            if ctx.getChildCount() == 3:
                if ctx.getChild(0).getText() == "(":
                    self.result[ctx] = self.result[ctx.getChild(1)]
                else:
                    opc = ctx.getChild(1).getText()
                    v1 = self.result[ctx.getChild(0)]
                    v2 = self.result[ctx.getChild(2)]
                    if opc == "+":
                        self.result[ctx] = v1 + v2
                    elif opc == "-":
                        self.result[ctx] = v1 - v2
                    elif opc == "*":
                        self.result[ctx] = v1 * v2
                    elif opc == "/":
                        self.result[ctx] = v1 / v2
                    else:
                        ctx.result[ctx] = 0
            elif ctx.getChildCount() == 2:
                opc = ctx.getChild(0).getText()
                if opc == "+":
                    v = self.result[ctx.getChild(1)]
                    self.result[ctx] = v
                elif opc == "-":
                    v = self.result[ctx.getChild(1)]
                    self.result[ctx] = - v
            elif ctx.getChildCount() == 1:
                self.result[ctx] = self.result[ctx.getChild(0)]

        def exitStart_(self, ctx:ExprParser.Start_Context):
            for i in range(0, ctx.getChildCount(), 2):
                print(self.result[ctx.getChild(i)])
    ```

## C++ `-Dlanguage=Cpp`
The C++ target supports all platforms that can either run MS Visual Studio 2017 (or newer), XCode 7 (or newer) or CMake (C++17 required). All build tools can either create static or dynamic libraries, both as 64bit or 32bit arch. Additionally, XCode can create an iOS library. Also see [Antlr4 for C++ with CMake: A practical example](http://blorente.me/beyond-the-loop/Antlr-cpp-cmake/).

### How to create a C++ lexer or parser?
This is pretty much the same as creating a Java lexer or parser, except you need to specify the language target, for example:

```
$ antlr4 -Dlanguage=Cpp MyGrammar.g4
```

You will see that there are a whole bunch of files generated by this call. If visitor or listener are not suppressed (which is the default) you'll get:

* MyGrammarLexer.h + MyGrammarLexer.cpp
* MyGrammarParser.h + MyGrammarParser.cpp
* MyGrammarVisitor.h + MyGrammarVisitor.cpp
* MyGrammarBaseVisitor.h + MyGrammarBaseVisitor.cpp
* MyGrammarListener.h + MyGrammarListener.cpp
* MyGrammarBaseListener.h + MyGrammarBaseListener.cpp

### Where can I get the runtime?

Once you've generated the lexer and/or parser code, you need to download or build the runtime. Prebuilt C++ runtime binaries for Windows (Visual Studio 2013/2015), OSX/macOS and iOS are available on the ANTLR web site:

* http://www.antlr.org

Use CMake to build a Linux library (works also on OSX, however not for the iOS library).

Instead of downloading a prebuilt binary you can also easily build your own library on OSX or Windows. Just use the provided projects for XCode or Visual Studio and build it. Should work out of the box without any additional dependency.


### How do I run the generated lexer and/or parser?

Putting it all together to get a working parser is really easy. Look in the [runtime/Cpp/demo](https://github.com/antlr/antlr4/tree/master/runtime/Cpp/demo) folder for a simple example. The README there describes shortly how to build and run the demo on OSX, Windows or Linux.

### How do I create and run a custom listener?

The generation step above created a listener and base listener class for you. The listener class is an abstract interface, which declares enter and exit methods for each of your parser rules. The base listener implements all those abstract methods with an empty body, so you don't have to do it yourself if you just want to implement a single function. Hence use this base listener as the base class for your custom listener:

```c++
#include <iostream>

#include "antlr4-runtime.h"
#include "MyGrammarLexer.h"
#include "MyGrammarParser.h"
#include "MyGrammarBaseListener.h"

using namespace antlr4;

class TreeShapeListener : public MyGrammarBaseListener {
public:
  void enterKey(ParserRuleContext *ctx) override {
	// Do something when entering the key rule.
  }
};


int main(int argc, const char* argv[]) {
  std::ifstream stream;
  stream.open(argv[1]);
  ANTLRInputStream input(stream);
  MyGrammarLexer lexer(&input);
  CommonTokenStream tokens(&lexer);
  MyGrammarParser parser(&tokens);

  tree::ParseTree *tree = parser.key();
  TreeShapeListener listener;
  tree::ParseTreeWalker::DEFAULT.walk(&listener, tree);

  return 0;
}

```
 
This example assumes your grammar contains a parser rule named `key` for which the `enterKey` function was generated.

### Special cases for this ANTLR target
There are a couple of things that only the C++ ANTLR target has to deal with. They are described here.

#### Code Generation Aspects
The code generation (by running the ANTLR4 jar) allows to specify 2 values you might find useful for better integration of the generated files into your application (both are optional):

* A **namespace**: use the **`-package`** parameter to specify the namespace you want.
* An **export macro**: especially in VC++ extra work is required to export your classes from a DLL. This is usually accomplished by a macro that has different values depending on whether you are creating the DLL or import it. The ANTLR4 runtime itself also uses one for its classes:

```c++
  #ifdef ANTLR4CPP_EXPORTS
    #define ANTLR4CPP_PUBLIC __declspec(dllexport)
  #else
    #ifdef ANTLR4CPP_STATIC
      #define ANTLR4CPP_PUBLIC
    #else
      #define ANTLR4CPP_PUBLIC __declspec(dllimport)
    #endif
  #endif
```
Just like the `ANTLR4CPP_PUBLIC` macro here you can specify your own one for the generated classes using the **`-DexportMacro=...`** command-line parameter or
grammar option `options {exportMacro='...';}` in your grammar file.

In order to create a static lib in Visual Studio define the `ANTLR4CPP_STATIC` macro in addition to the project settings that must be set for a static library (if you compile the runtime yourself).

For gcc and clang it is possible to use the `-fvisibility=hidden` setting to hide all symbols except those that are made default-visible (which has been defined for all public classes in the runtime).

#### Compile Aspects

When compiling generated files, you can configure a compile option according to your needs (also optional):

* A **thread local DFA macro**: Add `-DANTLR4_USE_THREAD_LOCAL_CACHE=1` to the compilation options
will enable using thread local DFA cache (disabled by default), after that, each thread uses its own DFA.
This will increase memory usage to store thread local DFAs and redundant computation to build thread local DFAs (not too much).
The benefit is that it can improve the concurrent performance running with multiple threads.
In other words, when you find your concurent throughput is not high enough, you should consider turning on this option.

#### Memory Management
Since C++ has no built-in memory management we need to take extra care. For that we rely mostly on smart pointers, which however might cause time penalties or memory side effects (like cyclic references) if not used with care. Currently however the memory household looks very stable. Generally, when you see a raw pointer in code consider this as being managed elsewhere. You should never try to manage such a pointer (delete, assign to smart pointer etc.).

Accordingly a parse tree is only valid for the lifetime of its parser. The parser, in turn, is only valid for the lifetime of its token stream, and so on back to the original `ANTLRInputStream` (or equivalent). To retain a tree across function calls you'll need to create and store all of these and `delete` all but the tree when you no longer need it.

#### Unicode Support
Encoding is mostly an input issue, i.e. when the lexer converts text input into lexer tokens. The parser is completely encoding unaware.

The C++ target always expects UTF-8 input (either in a string or stream) which is then converted to UTF-32 (a char32_t array) and fed to the lexer.

#### Named Actions
In order to help customizing the generated files there are a number of additional so-called **named actions**. These actions are tight to specific areas in the generated code and allow to add custom (target specific) code. All targets support these actions

* @parser::header
* @parser::members
* @lexer::header
* @lexer::members

(and their scopeless alternatives `@header` and `@members`) where header doesn't mean a C/C++ header file, but the top of a code file. The content of the header action appears in all generated files at the first line. So it's good for things like license/copyright information.

The content of a *members* action is placed in the public section of lexer or parser class declarations. Hence it can be used for public variables or predicate functions used in a grammar predicate. Since all targets support *header* + *members* they are the best place for stuff that should be available also in generated files for other languages.

In addition to that the C++ target supports many more such named actions. Unfortunately, it's not possible to define new scopes (e.g. *listener* in addition to *parser*) so they had to be defined as part of the existing scopes (*lexer* or *parser*). The grammar in the demo application contains all of the named actions as well for reference. Here's the list:

* **@lexer::preinclude** - Placed right before the first #include (e.g. good for headers that must appear first, for system headers etc.). Appears in both lexer h and cpp file.
* **@lexer::postinclude** - Placed right after the last #include, but before any class code (e.g. for additional namespaces). Appears in both lexer h and cpp file.
* **@lexer::context** - Placed right before the lexer class declaration. Use for e.g. additional types, aliases, forward declarations and the like. Appears in the lexer h file.
* **@lexer::declarations** - Placed in the private section of the lexer declaration (generated sections in all classes strictly follow the pattern: public, protected, private, from top to bottom). Use this for private vars etc.
* **@lexer::definitions** - Placed before other implementations in the cpp file (but after *@postinclude*). Use this to implement e.g. private types.

For the parser there are the same actions as shown above for the lexer. In addition to that there are even more actions for visitor and listener classes:

* **@parser::listenerpreinclude**
* **@parser::listenerpostinclude**
* **@parser::listenerdeclarations**
* **@parser::listenermembers**
* **@parser::listenerdefinitions**
* 
* **@parser::baselistenerpreinclude**
* **@parser::baselistenerpostinclude**
* **@parser::baselistenerdeclarations**
* **@parser::baselistenermembers**
* **@parser::baselistenerdefinitions**
* 
* **@parser::visitorpreinclude**
* **@parser::visitorpostinclude**
* **@parser::visitordeclarations**
* **@parser::visitormembers**
* **@parser::visitordefinitions**
* 
* **@parser::basevisitorpreinclude**
* **@parser::basevisitorpostinclude**
* **@parser::basevisitordeclarations**
* **@parser::basevisitormembers**
* **@parser::basevisitordefinitions**

and should be self explanatory now. Note: there is no *context* action for listeners or visitors, simply because they would be even less used than the other actions and there are so many already.

## JavaScript `-Dlanguage=JavaScript`

### Which browsers are supported?

In theory, all browsers supporting ECMAScript 5.1.

In practice, this target has been extensively tested against:

* Firefox 34.0.5
* Safari 8.0.2
* Chrome 39.0.2171
* Explorer 11.0.3
 
The above tests were conducted using Selenium. No issue was found, so you should find that the runtime works pretty much against any recent JavaScript engine.

### Is NodeJS supported?

The runtime has also been extensively tested against Node.js 14 LTS. No issue was found. NodeJS together with a packaging tool is now the preferred development path, developers are encouraged to follow it.

### What about modules?

Starting with version 8.1, Antlr4 JavaScript runtime follows esm semantics (see https://tc39.es/ecma262/#sec-modules for details)
Generated lexers, parsers, listeners and visitors also follow this new standard.
If you have used previous versions of the runtime, you will need to migrate and make your parser a module.

### How to create a JavaScript lexer or parser?

This is pretty much the same as creating a Java lexer or parser, except you need to specify the language target, for example:

```bash
$ antlr4 -Dlanguage=JavaScript MyGrammar.g4
```

For a full list of antlr4 tool options, please visit the [tool documentation page](tool-options.md).

### Where can I get the runtime?

Once you've generated the lexer and/or parser code, you need to download the runtime.

The JavaScript runtime is [available from npm](https://www.npmjs.com/package/antlr4).

We will not document here how to refer to the runtime from your project, since this would differ a lot depending on your project type and IDE. 

### How do I get the runtime in my browser?

The runtime is quite big and is currently maintained in the form of around 50 scripts, which follow the same structure as the runtimes for other targets (Java, C#, Python...).

This structure is key in keeping code maintainable and consistent across targets.

However, it would be a bit of a problem when it comes to get it into a browser. Nobody wants to write 50 times:

```
<script src='lib/myscript.js'>
```

To avoid having doing this, the preferred approach is to bundle antlr4 with your parser code, using webpack.

You can get [information on webpack here](https://webpack.github.io).

The steps to create your parsing code are the following:
 - generate your lexer, parser, listener and visitor using the antlr tool
 - write your parse tree handling code by providing your custom listener or visitor, and associated code, using 'require' to load antlr.
 - create an index.js file with the entry point to your parsing code (or several if required).
 - test your parsing logic thoroughly using node.js
 
You are now ready to bundle your parsing code as follows:
 - following webpack specs, create a webpack.config file
 - For Webpack version 5,
   - in the `webpack.config` file, exclude node.js only modules using: `resolve: { fallback: { fs: false } }`
 - For older versions of Webpack,
   - in the `webpack.config` file, exclude node.js only modules using: `node: { module: "empty", net: "empty", fs: "empty" }`
 - from the cmd line, navigate to the directory containing webpack.config and type: webpack
 
This will produce a single js file containing all your parsing code. Easy to include in your web pages!

### How do I run the generated lexer and/or parser?

Let's suppose that your grammar is named, as above, "MyGrammar". Let's suppose this parser comprises a rule named "MyStartRule". The tool will have generated for you the following files:

*   MyGrammarLexer.js
*   MyGrammarParser.js
*   MyGrammarListener.js (if you have not activated the -no-listener option)
*   MyGrammarVisitor.js (if you have activated the -visitor option)
   
(Developers used to Java/C# ANTLR will notice that there is no base listener or visitor generated, this is because JavaScript having no support for interfaces, the generated listener and visitor are fully fledged classes)

Now a fully functioning script might look like the following:

```javascript
import antlr4 from 'antlr4';
import MyGrammarLexer from './MyGrammarLexer.js';
import MyGrammarParser from './MyGrammarParser.js';
import MyGrammarListener from './MyGrammarListener.js';

const input = "your text to parse here"
const chars = new antlr4.InputStream(input);
const lexer = new MyGrammarLexer(chars);
const tokens = new antlr4.CommonTokenStream(lexer);
const parser = new MyGrammarParser(tokens);
const tree = parser.MyStartRule();
```

This program will work. But it won't be useful unless you do one of the following:

* you visit the parse tree using a custom listener
* you visit the parse tree using a custom visitor
* your grammar comprises production code (like AntLR3)
 
(please note that production code is target specific, so you can't have multi target grammars that include production code)
 
### How do I create and run a visitor?

Suppose your grammar is named "Query", the parser comprises a rule named "MyQuery", and the tool has generated the following files for you:

*   QueryLexer.js
*   QueryParser.js
*   QueryListener.js (if you have not activated the -no-listener option)

```javascript
// test.js
import antlr4 from 'antlr4';
import MyGrammarLexer from './QueryLexer.js';
import MyGrammarParser from './QueryParser.js';
import MyGrammarListener from './QueryListener.js';

const input = "field = 123 AND items in (1,2,3)"
const chars = new antlr4.InputStream(input);
const lexer = new MyGrammarLexer(chars);
const tokens = new antlr4.CommonTokenStream(lexer);
const parser = new MyGrammarParser(tokens);
const tree = parser.MyQuery();

class Visitor {
  visitChildren(ctx) {
    if (!ctx) {
      return;
    }

    if (ctx.children) {
      return ctx.children.map(child => {
        if (child.children && child.children.length != 0) {
          return child.accept(this);
        } else {
          return child.getText();
        }
      });
    }
  }
}

tree.accept(new Visitor());
````

## How do I create and run a custom listener?

Let's suppose your MyGrammar grammar comprises 2 rules: "key" and "value". The antlr4 tool will have generated the following listener: 

```javascript
class MyGrammarListener extends ParseTreeListener {
    constructor() {
        super();
    }
   
    enterKey(ctx) {}
    exitKey(ctx) {}
    enterValue(ctx) {}
    exitValue(ctx) {}
}
```

In order to provide custom behavior, you might want to create the following class:

```javascript
class KeyPrinter extends MyGrammarListener {
    // override default listener behavior
    exitKey(ctx) {
        console.log("Oh, a key!");
    }
}
```

In order to execute this listener, you would simply add the following lines to the above code:

```javascript
...
tree = parser.MyStartRule() // assumes grammar "MyGrammar" has rule "MyStartRule"
const printer = new KeyPrinter();
antlr4.tree.ParseTreeWalker.DEFAULT.walk(printer, tree);
```

## TypeScript `-Dlanguage=TypeScript`

## Swift `-Dlanguage=Swift`

## DART `-Dlanguage=Dart`

## PHP `-Dlanguage=PHP`

## Go `-Dlanguage=Go`

