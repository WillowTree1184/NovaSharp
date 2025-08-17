<!--
Copyright 2025 WillowTree1184 and contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

# NovaSharp 1.0 语言标准

NovaSharp 是一门不依赖于运行时的、支持面向对象与函数式范式的编程语言。

## 命名规范

NovaSharp 源码文件扩展名固定为 `.ns`。

对于以下内容，推荐采用对应的命名法则：

| 类别            | 规则        | 示例                                    |
| --------------- | ----------- | --------------------------------------- |
| 局部变量、字段  | camelCase   | `itemCount`                             |
| 全局变量、字段  | PascalCase  | `CacheSize`                             |
| 常量            | SNAKE_CASE  | `INT_MAX`                               |
| 类 / 结构体     | PascalCase  | `Account`                               |
| 枚举 / 枚举成员 | PascalCase  | `ComponentActivity`                     |
| 接口            | IPascalCase | `IComponent`（包含 I 前缀）             |
| 方法 / 函数     | PascalCase  | `GetAccountById`                        |
| 泛型            | TPascalCase | `T`（更为常用），`TItem`（包含 T 前缀） |

> [!TIP]
> 命名规范中提到的**局部变量、字段**是指**在函数内部定义的变量**或者**带有 `protected`、`private` 可访问性修饰符的字段**。

为了提高代码可读性与可维护性，我们**不推荐**在命名时采用**缩写**或者**没有意义的名称**，也不推荐采用**拼音**作为变量名。

## 基本语法

### 语句

NovaSharp 中的语句以分号 `;` 结尾。每个语句都是一个独立的执行单元，可以包含变量**声明**、**赋值**、**函数调用**等。

### 代码块

代码块用于将多个语句组合在一起，可被看作一行语句。在 NovaSharp 中，代码块使用大括号 `{}` 来定义。例如：

```novasharp
int a;

// 代码块
{
    int b;
    DoSomething();
    ...
}
// 代码块结束
```

### 作用域

作用域是指变量、函数等标识符可被访问的范围。

在 NovaSharp 中，作用域主要分为以下几种：

- **全局作用域**：在整个程序中都可以访问的标识符。
- **局部作用域**：在函数内部定义的标识符，只能在该函数内部访问。
- **块级作用域**：在代码块 `{}` 内部定义的标识符，只能在该代码块内部访问。

#### 作用域层级

在 NovaSharp 中，作用域的层级从内到外依次为：

1. **块级作用域**
2. **局部作用域**
3. **全局作用域**

### 注释

NovaSharp 中的注释分为单行注释和多行注释两种形式。

- 单行注释以 `//` 开头，直到行末结束。
- 多行注释以 `/*` 开始，以 `*/` 结束，可以跨越多行。

### 变量

变量是用于存储指定类型数据的空间，可以在程序中被引用和修改。

#### 变量声明

NovaSharp 中的变量声明分为**显式类型声明**和**隐式类型推断**两种方式。

变量声明语句采用 `[<修饰符1>, <修饰符2>, ...] <类型> <变量1名称> [= <变量1初始值>] [, <变量2名称> [= <变量2初始值>], ...]` 的形式。对于隐式类型推断，其 `<类型>` 为 `var`，且**必须提供初始值**，编译器会根据初始值的类型进行推断。样例如下：

```novasharp
int explicitType1 = 1, explicitType2; // 显式类型声明，前者已初始化为 1，后者默认为 0
var implicitType = 'a'; // 隐式类型推断（此处编译器推断为 char）
public int PublicProperty; // 带修饰符的类型声明
```

> [!IMPORTANT]
> 同一作用域中不允许出现同名变量。

#### 变量覆盖

NovaSharp 允许在不同的作用域中定义同名变量，例如：

```novasharp
class MyClass
{
    int x = 10;

    void MyFunction()
    {
        int x = 20;
        Console.WriteLine(x); // 输出: 20
    }
}
```

此时，NovaSharp 会优先使用内层作用域的同名变量 `x`，因此输出为 `20`。

在类或结构体内部，若需访问被同名局部变量覆盖的字段，可使用 `this` 关键字。例如：

```novasharp
class MyClass
{
    int x = 10;

    void MyFunction()
    {
        int x = 20;
        Console.WriteLine(this.x); // 输出: 10
    }
}
```

具体来说，`this` 关键字用于引用当前实例的成员，能够有效避免因变量覆盖而导致的歧义。详见[实例方法的隐式 this](#实例方法的隐式-this)。

#### 变量销毁

在 NovaSharp 中，**当变量离开作用域后，会自动销毁变量**。

变量的销毁并**不一定**伴随着内存的释放，也且不一定会**自动调用其析构函数**。详见[内存管理](#内存管理)。

如要手动**提前销毁变量**，可以使用 `delete` 语句。格式如下：

```novasharp
delete <变量名>;
```

例如：

```novasharp
int a = 10;
delete a;   // 销毁变量 a
```

> [!TIP]
> 使用 `delete` 语句提前销毁变量后，**无法再访问该变量**。

### 类型、基本类型与可空类型

NovaSharp 中的类型分为如下几类：

- 基本类型：包括 `int`、`float`、`double`、`char`、`bool`、数组等。
- 复合类型：包括结构体、类、接口。
- 引用类型：包括指针、委托。

完整的基本类型表格如下：

| 类型     | 解释                        | 默认值 |
| -------- | --------------------------- | ------ |
| `short`  | 2 字节整数                  | 0      |
| `ushort` | 2 字节**无符号**整数        | 0      |
| `int`    | 4 字节整数                  | 0      |
| `uint`   | 4 字节**无符号**整数        | 0      |
| `long`   | 8 字节整数                  | 0      |
| `ulong`  | 8 字节**无符号**整数        | 0      |
| `float`  | 4 字节浮点数                | 0.0    |
| `double` | 8 字节浮点数                | 0.0    |
| `char`   | 2 字节字符                  | '\0'   |
| `string` | 字符串                      | ""     |
| `bool`   | 1 字节布尔                  | false  |
| `[]`     | 数组                        | {}     |
| `object` | 对象 (所有的类型均派生于此) | null   |
| `void`   | 空类型                      | /      |

#### 整数、无符号整数与浮点数

整数类型用于表示整数值，包括有符号和无符号两种。浮点数类型用于表示带有小数部分的数值。

整数、无符号整数与浮点数类型提供如下方法：

| 定义                                         | 作用                                             |
| -------------------------------------------- | ------------------------------------------------ |
| `public string ToString()`                   | 将数值转换为字符串形式                           |
| `public static T Parse(string)`              | 将字符串解析为数值                               |
| `public static bool TryParse(string, out T)` | 尝试将字符串解析为数值，成功返回 true 并输出结果 |

> [!NOTE]
> 以上表格中，占位符 `T` 不是泛型占位符，它将被替换为对应的整数、无符号整数与浮点数类型。

允许整数与整数之间、无符号整数与无符号整数之间、浮点数与浮点数之间进行隐式转换。

> [!CAUTION]
> 不同类型之间的隐式转换可能会导致精度丢失，因此在进行隐式转换时需要谨慎。

#### 数组

数组是同一类型元素的集合，本质上是一块连续的内存区域，可以通过索引访问每个元素。数组的大小**在创建时确定**，不能动态改变。其索引**从 0 开始**。

> [!NOTE]
> 与 C++ 不同，NovaSharp 的数组不是一个指针。

创建数组实例的方式有如下两种：

1. 使用 `new` 关键字，通过 `new <类型>[<数量>]` 语句，显式创建一个大小为 `<数量>` 的数组实例。
2. 使用数组表达式。

数组表达式格式为 `{ <元素1>, <元素2>, ... }`，代表数组中的若干个元素，可以被隐式转换为数组。若将一个元素数量为 `n` 的数组表达式赋值给数组，则代表将该数组表达式的元素的前 `n` 个元素按照顺序从 0 号索引逐一赋值给目标数组，如果发生越界，将会抛出 `IndexOutOfRangeException` 异常。允许使用数组表达式初始化数组。

数组声明语句采用 `[<修饰符1>, <修饰符2>, ...] <类型>[] <变量名> [= <初始值>]` 的形式。样例如下：

```novasharp
int[] numbers; // 声明一个整型数组
int[] numbers = new int[10]; // 声明并初始化一个整型数组
int[] numbers = { 1, 2, 3, 4, 5 }; // 使用数组表达式初始化一个大小为 5 的数组
```

一个数组包含以下字段

- `Length`：（`int`, `readonly`）获取数组中元素的数量。

#### 字符与字符串

字符是用于表示单个文本字符的类型。在 NovaSharp 中，字符是不可变的，使用单引号 `'` 来表示。例如：

```novasharp
char letter = 'A';
```

字符串是用于表示文本数据的类型。在 NovaSharp 中，字符串的长度是不可变的，这意味着一旦创建，就无法修改其长度。字符串可以通过字面量创建，使用双引号 `"` 来表示，并提供一个索引器来访问字符串中的字符。例如：

```novasharp
string text = "Hello, World" ;
```

字符串的基本操作包括：

- **连接**：使用 `+` 运算符将多个字符串连接在一起，或者将字符串与字符连接，甚至将字符与字符连接。
- **比较**：使用 `==` 运算符比较两个字符串是否相等。

示例：

```novasharp
string firstName = "John";
string lastName = "Doe";
string fullName = firstName + " " + lastName; // "John Doe"

char dot = '·';
string dottedName = firstName + dot + lastName; // "John·Doe"

string message = $"Hello, {dottedName}!";
```

字符串提供一个构造函数用于创建一个指定大小的、用特定字符填充的空字符串，其定义如下：

```novasharp
public string(int size, char target = ' ');
```

字符串有如下字段和方法：

| 定义                                                             | 作用                                           |
| ---------------------------------------------------------------- | ---------------------------------------------- |
| `int Length`                                                     | 获取字符串的长度                               |
| `public string ToUpper()`                                        | 将字符串复制并转换为大写形式作为返回值。       |
| `public string ToLower()`                                        | 将字符串复制并转换为小写形式作为返回值。       |
| `public string Substring(int length)`                            | 返回从头开始的、指定长度的子字符串。           |
| `public string Substring(int start, int end)`                    | 返回从指定位置开始到结束位置的子字符串。       |
| `public string Trim()`                                           | 移除字符串两端的空白字符并返回新字符串。       |
| `public string PadLeft(int totalWidth, char paddingChar = ' ')`  | 在字符串左侧填充指定字符，直到达到指定总宽度。 |
| `public string PadRight(int totalWidth, char paddingChar = ' ')` | 在字符串右侧填充指定字符，直到达到指定总宽度。 |
| `public string Replace(string oldValue, string newValue)`        | 替换字符串中的指定子字符串并返回新字符串。     |
| `public string Replace(char oldValue, char newValue)`            | 替换字符串中的指定字符并返回新字符串。         |
| `public string Insert(int index, string value)`                  | 在指定位置插入字符串并返回新字符串。           |
| `public string Remove(int start, int length = 1)`                | 移除指定位置开始的子字符串并返回新字符串。     |
| `public string[] Split(char separator)`                          | 将字符串拆分为多个子字符串并返回字符串数组。   |
| `public string[] Split(char[] separators)`                       | 将字符串拆分为多个子字符串并返回字符串数组。   |

字符串可以被隐式或显式转换为 `char[]`。

#### 转义标识符

在 NovaSharp 中，可以使用反斜杠 `\` 来转义特殊字符。例如：

```novasharp
string path = "C:\\Program Files\\MyApp";
```

具体的转义标识符如下表：

| 标识符  | 对应字符                       |
| ------- | ------------------------------ |
| `\\`    | 反斜杠                         |
| `\'`    | 单引号                         |
| `\"`    | 双引号                         |
| `\n`    | 换行符                         |
| `\t`    | 制表符                         |
| `\0`    | 空字符                         |
| `\b`    | 退格符                         |
| `\f`    | 换页符                         |
| `\v`    | 垂直制表符                     |
| `\r`    | 回车符                         |
| `\a`    | 响铃符                         |
| `\u{n}` | Unicode 字符（以字符 \u 开头） |

#### 字符串内嵌变量

在 NovaSharp 中，可以使用 `$` 符号和大括号 `{}` 来插入变量值，大括号中的内容会被隐式转换为字符串。例如：

```novasharp
string greeting = $"Hello, {fullName}! I'm {age} years old."; // 此处 age 被隐式转换为字符串
```

如需在带 `$` 符号的字符串中使用大括号，可以使用双大括号 `{{` 和 `}}` 来转义。例如：

```novasharp
string message = $"Hello, {{user}}!"; // 输出: Hello, {user}!
```

#### 富文本字符串

富文本字符串是一种用于表示包含格式化文本的字符串类型。在 NovaSharp 中，富文本字符串使用三重引号 `"""` 来表示。它同时支持内嵌变量。例如：

```novasharp
string helloText = "Hello World!!!!";
string richText = $"""
{helloText}
This is a rich text string.
It can \span multiple lines/.
"""
```

#### 元组

元组是一种可用于存储多个不同类型数据项的复合类型，适合在无需专门定义结构体或类的场景下，将多个相关值组合在一起。

在 NovaSharp 中，元组作为类型时的声明格式为 `(<类型1> [<类型名1>], <类型2> [<类型名2>], ...)`，作为值或参数时的声明格式为 `([<值名称1>:] <值1>, [<值名称2>:] <值2>, ...)`，元组的元素数量和类型在声明时确定，声明后不可更改。

元组的定义与初始化示例：

```novasharp
(string, int) person = ("Alice", 30); // 显式声明类型
(string Name, int Age) person = ("Alice", 30);
var info = ("Bob", 25, true); // 隐式类型推断
var info = (Name: "Bob", Age: 25, IsStudent: true);
```

元组中未声明类型名的元素可通过 `.Item1`、`.Item2` 等字段访问，字段名按元素顺序自动生成。例如：

```novasharp
var info = ("Bob", 25, true);

Console.WriteLine(info.Item1); // 输出: Bob
Console.WriteLine(info.Item2); // 输出: 25
Console.WriteLine(info.Item3); // 输出: True
```

元组支持解构赋值，可将元素分别赋值给多个变量：

```novasharp
(string Name, int Age) person = ("Alice", 30);
string name;
int age;
var (name, age) = person;
```

> [!IMPORTANT]
> 解构变量类型需与元组元素类型兼容。

元组可被嵌套使用：

```novasharp
var nested = (Name: "Eve", Info: (Age: 20, Score: 95));
Console.WriteLine(nested.Info.Score); // 输出: 95
```

#### 可空类型

可空类型是指可以赋值为 `null` 的值类型。在 NovaSharp 中，所有值类型都可以被声明为可空类型。

要声明一个可空类型，可以在类型后面使用 `?` 后缀。例如：

```novasharp
int? nullableInt = null; // 可空整型
```

##### 空合并运算符

空合并运算符 `??` 用于简化对可空类型的处理。当一个可空类型的值为 `null` 时，可以使用空合并运算符提供一个默认值。

例如：

```novasharp
int? nullableInt = null;
int value = nullableInt ?? 0; // 如果 nullableInt 为 null，则使用 0；否则使用 nullableInt 的值
```

##### 空条件访问

空条件访问运算符 `?.` 用于简化对可空类型的访问。仅当左操作数非 `null` 时才继续访问成员；否则整个表达式结果为 `null`。

例如：

```novasharp
string? name = null;
int? length = name?.Length; // 如果 name 为 null，则 length 为 null；否则使用 name 的长度
```

#### 类型转换

NovaSharp 中的类型转换分为隐式转换和显式转换。

- **隐式转换**：在不丢失信息的情况下，自动进行的类型转换。例如，将 `int` 类型的值赋给 `float` 类型的变量。

  例如：

  ```novasharp
  float f = 3.14f;
  double i = f; // 隐式转换，将 float 转换为 double，此时 i 的值为 3.14
  ```

- **显式转换**：需要使用转换操作符进行的类型转换。例如，将 `float` 类型的值转换为 `int` 类型时，需要使用 `(int)` 进行显式转换。

  例如：

  ```novasharp
  float f = 3.14f;
  int i = (int)f; // 显式转换，指定将 float 转换为 int，精度截断，此时 i 的值为 3
  ```

类型转换的本质是调用类型转换函数。

类型转换函数是一类特殊的函数，用于实现不同类型之间的转换逻辑。在类与结构体中，类型转换函数可以被创建或重载，以支持自定义的类型转换逻辑。对于隐式转换函数，须加上 `implicit` 修饰符；对于显式转换函数，须加上 `explicit` 修饰符。若同时支持显式和隐式转换，且实现逻辑相同，则可以同时使用 `implicit` 和 `explicit` 修饰符。

格式如下：

```novasharp
[implicit] [explicit] operator <目标类型>(<源类型> <变量名>)
{
 // 转换逻辑
}
```

例如：

```novasharp
class Temperature
{
    public float Celsius { get; set; }

    implicit operator Temperature(float celsius)
    {
        return new Temperature { Celsius = celsius };
    }

    explicit operator float(Temperature temp)
    {
        return temp.Celsius;
    }
}
```

> [!IMPORTANT]
> 类型转换函数的返回值类型为目标类型。另外，类型转换函数是静态函数，并且可访问性为 `public`。

### 修饰符

NovaSharp 中的修饰符用于控制类、结构体、函数、变量等的可见性和行为。

| 修饰符       | 解释   | 特性 / 用途                                                                                        |
| ------------ | ------ | -------------------------------------------------------------------------------------------------- |
| `public`     | 公有   | （可访问性修饰符）可以在**对象之外**被访问                                                         |
| `private`    | 私有   | （可访问性修饰符）只能在**对象内部**被访问                                                         |
| `protected`  | 受保护 | （可访问性修饰符）只能在**对象内部**或**派生类**中被访问                                           |
| `internal`   | 内部   | （可访问性修饰符）只能在**同一程序集**内被访问                                                     |
| `static`     | 静态   | 属于**对象**而非其实例                                                                             |
| `readonly`   | 只读   | （仅对于变量）只能在**初始化时**或者**构造函数**中被赋值                                           |
| `const`      | 常量   | 只能在**初始化时**被赋值                                                                           |
| `volatile`   | 易变   | 不被编译器优化                                                                                     |
| `abstract`   | 抽象   | （仅对于类）该成员在派生类中必须被重写                                                             |
| `sealed`     | 密封   | （仅对于类或其成员）该对象不能被继承或重写                                                         |
| `virtual`    | 虚拟   | （仅对于类中的函数）该成员可以在派生类中被重写                                                     |
| `override`   | 重写   | （仅对于类中的虚函数）允许在派生类中重新定义基类中的成员                                           |
| `implicit`   | 隐式   | （仅对于类中的函数）声明隐式转换函数                                                               |
| `explicit`   | 显式   | （仅对于类中的函数）声明显式转换函数                                                               |
| `out`        | 输出   | （仅对于函数参数）按引用传递参数，允许在函数内部修改外部变量的值，并且在函数返回时必须为该参数赋值 |
| `ref`        | 引用   | （仅对于函数参数与变量）声明引用类型                                                               |
| `operator`   | 运算符 | （仅对于类中的函数）声明运算符重载函数                                                             |
| `get`        | 获取   | （仅对于索引器）声明获取索引器                                                                     |
| `set`        | 设置   | （仅对于索引器）声明设置索引器                                                                     |
| `penetrated` | 穿透   | （仅对于变量或临时变量）绕过对象索引表机制，将变量或临时变量直接存储到内存中                       |
| `coroutine`  | 协程   | （仅对于函数、方法与变量）声明协程函数                                                             |

#### 可访问性大小关系

对于所有的可访问性修饰符，它们的可访问性大小关系如下：

```
public > internal > protected > private
```

### 赋值语句

赋值语句用于将变量的值设置为另一个值。

具体的流程是, 先计算目标值，并将目标值隐式转换为赋值目标的类型，然后再将其拷贝到赋值目标的内存中。

其基本语法为 `<赋值目标> = <目标值>`。在赋值时，变量的类型必须与赋值的值的类型兼容。

### 运算与表达式

在 NovaSharp 中，运算符用于执行各种操作，包括**算术运算**、**比较运算**和**逻辑运算**等。运算符可以与**操作数结合**形成**表达式**，表达式的值可以用于**赋值**、**条件判断**等场景。

#### 运算符

以下运算符，优先级值越大越先被处理。

数学运算符：

| 运算符 | 说明     | 使用方法 | 优先级 |
| ------ | -------- | -------- | ------ |
| `+`    | 加法     | `a + b`  | 1      |
| `++`   | 自增     | `a++`    | 3      |
| `-`    | 减法     | `a - b`  | 1      |
| `--`   | 自减     | `a--`    | 3      |
| `*`    | 乘法     | `a * b`  | 2      |
| `/`    | 除法     | `a / b`  | 2      |
| `%`    | 取模     | `a % b`  | 2      |
| `==`   | 等于     | `a == b` | 3      |
| `!=`   | 不等于   | `a != b` | 3      |
| `>`    | 大于     | `a > b`  | 3      |
| `<`    | 小于     | `a < b`  | 3      |
| `>=`   | 大于等于 | `a >= b` | 3      |
| `<=`   | 小于等于 | `a <= b` | 3      |

逻辑运算符：

| 运算符 | 说明   | 使用方法   | 优先级 |
| ------ | ------ | ---------- | ------ |
| `&&`   | 逻辑与 | `a && b`   | 4      |
| `\|\|` | 逻辑或 | `a \|\| b` | 4      |
| `!`    | 逻辑非 | `!a`       | 5      |

位运算符：

| 运算符 | 说明     | 使用方法 | 优先级 |
| ------ | -------- | -------- | ------ |
| `&`    | 按位与   | `a & b`  | 6      |
| `\|`   | 按位或   | `a \| b` | 6      |
| `^`    | 按位异或 | `a ^ b`  | 6      |
| `~`    | 按位取反 | `~a`     | 5      |
| `<<`   | 左移     | `a << b` | 6      |
| `>>`   | 右移     | `a >> b` | 6      |

赋值运算符：

| 运算符 | 说明         | 使用方法  | 优先级 |
| ------ | ------------ | --------- | ------ |
| `+=`   | 加法赋值     | `a += b`  | 1      |
| `-=`   | 减法赋值     | `a -= b`  | 1      |
| `*=`   | 乘法赋值     | `a *= b`  | 2      |
| `/=`   | 除法赋值     | `a /= b`  | 2      |
| `%=`   | 取模赋值     | `a %= b`  | 2      |
| `&=`   | 按位与赋值   | `a &= b`  | 6      |
| `\|=`  | 按位或赋值   | `a \|= b` | 6      |
| `^=`   | 按位异或赋值 | `a ^= b`  | 6      |
| `<<=`  | 左移赋值     | `a <<= b` | 6      |
| `>>=`  | 右移赋值     | `a >>= b` | 6      |

> [!TIP]
> 以加法赋值运算符为例：它的本质是 `a = a + b`。

其它运算符：

| 运算符 | 说明         | 使用方法 | 优先级 |
| ------ | ------------ | -------- | ------ |
| `??`   | 空合并运算符 | `a ?? b` | 0      |
| `in`   | 成员运算符   | `a in b` | 0      |
| `is`   | 类型运算符   | `a is b` | 0      |

> [!NOTE]
> 成员运算符 `in` 用于检查 b 是否包含 a。此处 b 必须是一个数组或可以被隐式转换为数组的类型。
>
> 类型运算符 `is` 用于检查 a 是否是 b 类型的实例。

其中，优先级越高的运算符**先被计算**，优先级相同的运算符会**按照从左到右的顺序**计算。允许使用小括号来改变运算顺序，使其中的表达式优先级最高，例如 `(a + b) * c` 中，`(a + b)` 会先被计算，从而影响计算结果。

#### 运算符重载

运算符的本质是一种特殊的函数，允许通过运算符重载来定义或修改该函数的行为。

在 NovaSharp 中，可以为自定义类型重载常见的运算符，例如 `+`、`-`、`*`、`/` 等，以实现更直观的操作。

运算符重载的格式如下：

```novasharp
<返回值类型> operator <运算符>(<参数a的类型> <参数a>, [<参数b的类型> <参数b>])
{
 // 函数体
}
```

例如，可以为一个表示二维点的结构体重载 `+` 运算符，以便直接相加两个点：

```novasharp
struct Point
{
    public int X;
    public int Y;

    Point operator +(Point p1, Point p2)
    {
        return new Point { X = p1.X + p2.X, Y = p1.Y + p2.Y };
    }
}
```

> [!IMPORTANT]
> 运算符重载只能在结构体或类内部定义。运算符重载的修饰符固定为 `public static`，不能也不需要为运算符重载指定修饰符。

#### 表达式

表达式是由操作数和运算符组成的式子，可以计算出一个值。这个值类型由其操作数和运算符决定。表达式可以是简单的，也可以是复杂的。

- 简单表达式：由单个操作数构成，例如 `5`、`x`。
- 复杂表达式：由多个操作数和运算符构成，例如 `a + b * c`。

```novasharp
int a = 5;
int b = 10;
int c = a + b * 15; // 复杂表达式
```

允许将函数作为操作数，其值为该函数的返回值。

```novasharp
int Calculate(int x, int y) {
    return x + y * 15;
}

int a = 5;
int b = 10;
int c = Calculate(a, b);
```

### 指针与取地址

> [!CAUTION]
> 从内存安全考虑，我们非常不建议使用指针。请优先考虑使用引用。

指针是**一类**类型，它们存储另一个变量的**内存地址**。通过指针，可以间接访问和修改该变量的值。

在 NovaSharp 中，如要声明指针类型变量，须在类型后面使用 `*` 符号。例如：

```novasharp
int a = 5;
int* p = &a; // 声明一个指向整型的指针，并将其指向变量 a 的地址
int** u = &p; // 声明一个指向指针的指针，并将其指向变量 p 的地址
```

其中，另外，`&` 在此处是**取地址运算符**而**不是按位与运算符**，它用于获取变量的内存地址。原理详见[对指针的特殊处理与取地址相关规定](#对指针的特殊处理与取地址相关规定)。

在上述的例子中，`int*` 就是一个 **int 指针类型**，换言之，`int` 是指针 `p` 的**基类型**。实际上，对于每一种类型，都可以作为指针的基类型，包括指针本身。上述例子中的 `int**` 就是一个**“指向指针的指针”**。

> [!TIP]
> 指针**默认可空**。声明指针时，若不指定初始值，指针将被初始化为 `null`。

当需要获取指针指向的值时，可以使用解引用操作符 `*`。例如：

```novasharp
int a = 5;
int* p = &a; // 声明一个指向整型的指针，并将其指向变量 a 的地址
int b = *p; // 通过指针获取变量 a 的值
```

特别的，指针的基类型可以是一个泛型占位符，例如内存管理的[对象索引表与索引单元](#对象索引表与索引单元)一节中所描述的理想模型：

```novasharp
public struct IndexUnit<TObject>
{
    public TObject* ObjectPointer; // 一个指向类型为 TObject 的对象的指针
    public int ReferenceCount;
}
```

指针不能被 `penetrated` 修饰符修饰。原理详见 [`penetrated` 修饰符](#penetrated-修饰符)一节。

### 引用

引用是指向变量的别名，是指针的替代品，可以通过引用直接访问和修改变量的值。引用在函数参数传递时非常有用，可以避免复制大对象的开销。详见[内存管理](#内存管理)一节。

在 NovaSharp 中，当需要声明或传递一个引用时，可以使用 `ref` 关键字。例如：

```novasharp
int a = 5;
int r = ref a;
```

以上代码创建了一个变量 `r`，并将 `a` 的引用传递给它。可以大致理解为：此时`r` 绑定到变量 `a`，可以直接通过 `r` 访问和修改 `a` 的值。

> [!IMPORTANT]
> 只有当变量声明时将其**初始值**设为一个引用，才能创建引用。因此对于任何变量和字段，只能在变量声明时使用 `ref` 关键字，**不能在后续的赋值操作中使用**。

不能创建指针的引用。原理详见[内存管理](#内存管理)一节。对于声明了 `penetrated` 修饰符的变量也不能创建引用。相关内容详见 [`penetrated` 修饰符](#penetrated-修饰符)

#### 对于引用的引用

在 NovaSharp 中，当引用一个引用时，实际上是复制了该引用。这是因为引用并不存储实际数据，而是指向对应的索引单元。有关索引单元的内容，详见[对象索引表与索引单元](#对象索引表与索引单元)一节。

例如：

```novasharp
int a = 5;
int r = ref ref a; // 与 int r = ref a; 的效果相同，但原则上我们禁止这种写法
```

上述代码中创建了一个引用的 `ref a` 的引用，此时该引用仍旧指向 `a` 对应的索引单元。

> [!NOTE]
> 原则上，我们**禁止**在实际代码中使用引用的引用，因为这可能会导致混淆和错误。实际上，这种“对于引用的引用”的荒唐设计是考虑到“创建对**返回值为引用的表达式**的引用”的离谱情况发生的潜在可能性，尽管这种情况看上去少之又少，以至于我们无法给出实际且合理的样例。

### 流程控制

NovaSharp 提供了多种流程控制语句，用于控制程序的执行流程，包括条件语句、循环语句等。

流程控制语句的结尾不需要分号。

#### if 语句

if 语句用于根据条件的真假来决定执行不同的代码块。NovaSharp 中的 if 语句包括 `if` 和 `else`，它们的基本语法为 `if <条件> <代码块> [else <代码块>]`。其中，`<条件>` 是一个布尔类型的表达式，常见的使用方法如下：

```novasharp
if condition
{
    // 当条件为真时执行的代码块
}
else
{
    // 当所有条件都不满足时执行的代码块
}
```

由此可派生出 `else if` 语句，用于处理多个条件的情况。

```novasharp
if condition1
{
    // 当条件1为真时执行的代码
}
else if condition2
{
    // 当条件2为真时执行的代码
}
else
{
    // 当所有条件都不满足时执行的代码
}
```

`else if` 语句的本质如下：

```novasharp
if condition1
{
    // 当条件1为真时执行的代码
}
else
{
    if condition2
    {
        // 当条件2为真时执行的代码
    }
    else
    {
        // 当所有条件都不满足时执行的代码
    }
}
```

#### 模式匹配语句

模式匹配是一种强大的控制流机制，允许根据值的结构、类型或内容进行分支选择。它超越了传统的条件语句，提供更清晰、更安全的类型处理方式。

基本语法格式：

```novasharp
match <表达式>
{
    case <模式1>: <结果1>
    case <模式2>: <结果2>
    ...
    [default: <默认结果>]
}
```

`match` 支持以下匹配模式：

| 模式类型        | 示例                           | 说明                                                                 |
| --------------- | ------------------------------ | -------------------------------------------------------------------- |
| 常量模式        | `case 42:`                     | 匹配特定常量值                                                       |
| 类型模式        | `case int i:`                  | 匹配特定类型并提取值                                                 |
| 类型 + 逻辑模式 | `case int i when i > 0:`       | 匹配特定类型、提取值并判断是否符合条件                               |
| 解构模式        | `case Point(x, y):`            | 匹配、解构复杂类型（如：类、结构体、元组）并提取值                   |
| 解构 + 逻辑模式 | `case Point(x, y) when x > 0:` | 匹配、解构复杂类型（如：类、结构体、元组）、提取值名判断是否符合条件 |
| 属性模式        | `case { Length > 0 }`          | 基于属性值匹配                                                       |
| 逻辑模式        | `case > 0`                     | 使用逻辑运算符组合条件                                               |
| 默认模式        | `default:`                     | 匹配任何值                                                           |

使用样例：

```novasharp
// 基本类型匹配
object value = GetValue();

match value
{
    case int i when i > 0: // （类型 + 逻辑模式）value 为 int 类型且大于 0 时
        Console.WriteLine($"正整数: {i}");
    case string s: // （类型模式）value 为 string 类型时
        Console.WriteLine($"字符串长度: {s.Length}");
    case null: // （常量模式）value 为空时
        throw new ArgumentNullException();
    default: // （默认模式）匹配任何其他情况
        Console.WriteLine("未知类型");
}

// 解构复杂类型
struct Point
{
    int X;
    int Y;
}

Point p = new(3, 4);

match p
{
    case Point(0, 0):
        Console.WriteLine("原点");
    case Point(x, y) when x == y:
        Console.WriteLine("对角线上的点");
    case Point(_, 0):
        Console.WriteLine("X轴上的点");
    default:
        Console.WriteLine($"普通点: ({p.X}, {p.Y})");
}

// 集合模式匹配
int[] numbers = {1, 2, 3};

match numbers
{
    case int[] i when i[0] == 1:
        Console.WriteLine("以1开头的数组");
    case int[] i when i[1] == 2:
        Console.WriteLine("第二个元素是2");
    case {}:
        Console.WriteLine("空数组");
}

// 逻辑模式
match 1
{
    case == 0:
        Console.WriteLine($"等于0");
    case > 2:
        Console.WriteLine($"大于2");
    default:
        Console.WriteLine("其它");
}
```

> [!IMPORTANT]
> 模式中声明的变量仅在对应分支内有效。

#### 循环语句

循环语句用于重复执行循环体（即重复执行同一代码块），直到满足特定条件为止。NovaSharp 中的循环语句包括 `while` 循环、`do while` 循环、 `for` 循环和 `each` 循环。

其中：

- `while` 循环：在**条件为真**时重复执行循环体。其格式为 `while <条件> <循环体>`。

  样例如下:

  ```novasharp
  // while 循环
  while condition
  {
      doSomething(); // 当条件为真时重复执行的代码
  }
  ```

- `do while` 循环：**先执行循环体**，再判断条件是否为真。其格式为 `do <循环体> while <条件>`。

  样例如下:

  ```novasharp
  do
  {
      doSomething(); // 循环体
  } while condition;
  ```

- `for` 循环：通过**对循环变量进行操作**来控制循环——**执行前**运行初始化语句，当**条件为真**时执行循环体，每次**执行循环体后**运行更新语句。其格式为 `for <初始化>; <条件>; <更新> <循环体>`。

  样例如下:

  ```novasharp
  for int i = 0; i < 10; i++
  {
      doSomething(); // 循环体
  }
  ```

- `each` 循环：用于遍历集合中的每个元素。其格式为 `each <元素类型> <元素> in <集合> <循环体>`。若`<元素类型>`使用**隐式类型推断**（即 `var`），则可以省略。

  样例如下:

  ```novasharp
  int[] numbers = { 1, 2, 3, 4, 5 };

  each int i in numbers
  {
      doSomethingWith(i);
  }
  ```

  以上代码等价于

  ```novasharp
  each i in numbers
  {
  doSomethingWith(i);
  }
  ```

> [!TIP]
> 格式中的 `<集合>` 必须是一个数组或者能够隐式转换为数组的对象。并且，对于每一个元素，都是对集合中对应对象的引用。

#### `break` 和 `continue` 语句

`break` 语句用于立即终止循环或 `switch` 语句的执行，并跳出当前代码块。`continue` 语句用于跳过当前循环的剩余部分或当前 `case` 的剩余部分，直接进入下一次循环。

> [!IMPORTANT]
> 注意：`break` 和 `continue` 语句只能作用于其所在的循环或 `switch` 语句，不会在嵌套结构中的外层循环或外层 `switch` 语句中生效。

样例如下:

```novasharp
while condition
{
    if someCondition
    {
        break; // 跳出循环
    }
    if anotherCondition
    {
        continue; // 跳过当前循环，进入下一次循环
    }
}
```

若希望将 `break` 语句作用于嵌套结构中的所有循环，可以在其前方加上 `all` 关键字，但是该语法不适用于 `switch`，例如：

```novasharp
while condition1
{
    while condition2
    {
        if someCondition
        {
            all break; // 跳出所有嵌套循环
        }
    }
}
```

### 函数

NovaSharp 中的函数用于封装可重用的代码块。函数可以接收参数并返回值，支持多种参数类型和返回值类型。

一个函数的基本格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] <返回值类型> <函数名>(<参数1类型> <参数1>[, <参数2类型> <参数2>, <参数3类型> <参数3>, ...])
{
 // 函数体
}
```

其中，`<返回值类型>` 是函数返回值的类型，`<函数名>` 是函数的名称。

调用函数时，需要传入与形式参数类型匹配的实参。

样例如下:

```novasharp
// 函数定义
int Add(int a, int b)
{
    return a + b; // 计算 a 和 b 的和
}

// 函数调用
int result = Add(5, 10); // 调用 Add 函数，当传入的参数为 5 和 10 时，返回值为 15
```

若希望某些形式参数在调用时可以省略，可以为这些参数提供默认值。默认值的语法为`<参数名> = <默认值>`，并放在参数列表的末尾。

样例如下:

```novasharp
// 函数定义
int Add(int a, int b = 0)
{
    return a + b; // 计算 a 和 b 的和
}

// 函数调用
int result1 = Add(5, 10); // 调用 Add 函数，传入 5 和 10，返回值为 15
int result2 = Add(5); // 调用 Add 函数，传入 5，返回值为 5
```

#### `return` 语句

`return` 语句用于结束函数的执行，并返回一个值给调用者当作该函数的返回值。其基本语法为 `return <返回值>;`。

> [!IMPORTANT]
> 注意：`return` 语句只能出现在函数内部，且必须与函数的返回值类型匹配。且函数的任何执行路径都必须返回一个值。

对于返回值类型为 `void` 的函数，`return` 语句可以省略。若希望在某些情况下提前结束函数的执行，可以直接使用 `return;` 语句而不用携带返回值。

#### 函数重载

函数重载是指在同一个作用域内，可以定义多个**同名但参数列表不同**的函数，同时，不强制要求它们的返回值类型是否相同。编译器会根据函数调用时传入的参数类型和数量来决定调用哪个具体的函数。

以下是一个函数重载的示例：

```novasharp
// 函数定义
int Add(int a, int b)
{
    return a + b; // 计算 a 和 b 的和
}

double Add(double a, double b)
{
    return a + b; // 计算 a 和 b 的和
}

// 函数调用
int result1 = Add(5, 10); // 调用第一个 Add 函数，返回值为 15
double result2 = Add(5.5, 10.5); // 调用第二个 Add 函数，返回值为 16.0
```

> [!IMPORTANT]
> 同一作用域内且名称、参数列表与条件相同的函数**不能重载**。

#### 带条件的重载

若对于**同名、返回值类型相同且参数列表相同**的函数，希望**根据特定条件来选择调用哪个函数**，可以使用 `require` 语句来实现。使用`require` 语句的函数定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] <返回值类型> <函数名>(<参数列表>) require <重载条件>
{
    // 函数体
}
```

> [!IMPORTANT]
> NovaSharp **强制要求**这些**同名、返回值类型相同且参数列表相同**的函数**采用完全相同的修饰符**。

`<重载条件>` 可以是**任意的布尔表达式**，用于限制函数的调用。只有当条件都满足时，才会调用该函数。

例如：

```novasharp
void process(int type, int value) require type == 1
{
    // 处理 type == 1 时的情况
}

void process(int type, int value) require type == 2, value < 5 // 相当于 void process(int type, int value) require type == 2 && value < 5
{
    // 处理 type == 2 且 value < 5 时的情况
}

void process(int type, int value)
{
    // 处理其它情况
}
```

以上述代码为例，**在运行时**，对 `process(int type, int value)` 的调用操作将按照该函数的声明顺序从上到下匹配函数，带条件的函数会被优先匹配。若没有匹配的函数，则会调用不带条件的函数。当没有定义不带条件的函数时，将会抛出 `NoMatchingFunctionException` 异常。

本质上，以上代码是以下代码的语法糖：

```novasharp
// 该代码仅为示例，与实际编译期生成的代码在命名上可能有出入
void process_require_type_equal_1(int type, int value)
{
    // 处理 type == 1 时的情况
}

void process_require_type_equal_2_and_value_less_5(int type, int value)
{
    // 处理 type == 2 且 value < 5 时的情况
}

void process_default(int type, int value)
{
    // 处理其它情况
}

// 该函数选择器在编译时生成
// 调用process时，调用的是这个选择器
void process(int type, int value)
{
    if type == 1
    {
        return process_require_type_equal_1(type, value);
    }
    else if type == 2 && value < 5
    {
        return process_require_type_equal_2_and_value_less_5(type, value);
    }
    else
    {
        return process_default(type, value);
    }
}
```

> [!TIP]
> 以下内容为编译时可选项：
>
> - 是否优化条件重载
>
> 若开启，则在编译时，对**恒满足某一特定重载的重载条件**的调用，将会被优化为**直接调用该重载**，而**不再进行条件判断**。
>
> 该选项**默认开启**

#### 引用值与输出值

在 NovaSharp 中，可以通过引用参数和输出参数来实现函数的输入输出。

引用参数：在函数参数前加上 `ref` 关键字，表示该参数是引用传递。函数内部对该参数的修改会影响到外部变量。

样例如下:

```novasharp
void UpdateValue(ref int value)
{
    value += 10;
}

int Main()
{
    int x = 0;
    UpdateValue(x); // 此时传递x，注意，调用时不需要声明 ref
}
```

输出参数：在函数参数前加上 `out` 关键字，表示该参数是输出参数。函数内部必须对该参数赋值，才能在外部使用。

样例如下:

```novasharp
void Add(int a, int b, out int result)
{
    result = a + b;
}
```

> [!IMPORTANT]
> 输出参数必须在函数内部被赋值。在调用带有输出参数的函数时，必须使用 `out` 关键字来接收返回值。

样例如下:

```novasharp
int a, b, result;

Add(a, b, out result);
```

以上内容可被简写为

```novasharp
int a, b;

Add(a, b, out int result); // 变量 result 在此处定义
```

### 枚举

枚举是一种特殊的值类型，用于定义一组与整数类型常数相关联的名称。通过使用枚举，可以提高代码的可读性和可维护性。

在 NovaSharp 中，枚举的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] enum <枚举名>
{
    <枚举值1> [= <对应整数>],
    <枚举值2> [= <对应整数>],
    <枚举值3> [= <对应整数>],
    ...
}
```

> [!IMPORTANT]
> 每一个枚举值所对应的整数**不允许重复**。若不提供对应的整数，则默认从 0 开始依次递增，若出现冲突，则后面的枚举值会自动加 1 直至冲突避免。

样例如下:

```novasharp
public enum Color
{
    Red, // 对应值默认为 0
    Green = 2, // 原对应值为 1，由于有显式指定，则此处为 2
    Blue // 原对应值默认为 2, 由于没有显式指定，而且与 Green 冲突，于是默认为 3
}

/*
则实际上：

public enum Color
{
    Red = 0,
    Green = 2,
    Blue = 3
}
*/
```

### 对象、接口与继承

> [!NOTE]
> 本章中所提到的“对象”泛指 class、struct、interface；“方法”指对象中的函数。

#### 字段、属性与存取器

字段是对象中的变量，用于存储数据。例如：

```novasharp
public struct Point
{
    public int X;
    public int Y;
}
```

其中的 `X` 和 `Y` 是字段。

而属性，则是在对象中，**以字段的形式**提供一系列的**存取器**。也就是说，属性对外表现为字段，但内部由存取器实现。NovaSharp 允许以访问字段的形式访问属性，但是属性本质上**不是字段**，并不会像字段一样存储数据。

欲定义属性，可以使用以下格式：

```novasharp
[<修饰符1>, <修饰符2>, ...] <类型> <属性名>
{
    <存取器定义>
}
```

存取器是一种特殊的函数。NovaSharp 中存在两种存取器：

| 存取器 | 作用                 |
| ------ | -------------------- |
| get    | 处理对属性的读取操作 |
| set    | 处理对属性的赋值操作 |

例如：

```novasharp
public class Person
{
    private int identity; // 私有字段
    private int age; // 私有字段

    public Person(int id, age)
    {
        identity = id;
        this.age = age;
    }

    public int Id  // 公开的属性
    {
        get
        {
            return identity; // 当读取属性时，返回私有字段 identity 的值
        };
    }

    public int Age
    {
        get
        {
            return age; // 当读取属性时，返回私有字段 age 的值
        };

        set
        {
            age = value; //// 当写入属性时，设置私有字段 age 的值
        };
    }
}

int Main()
{
    Person willow = new Person(1, 15);

    // 以访问字段的形式访问属性
    willow.Age = 16;
    Console.WriteLine($"Name: {willow.Name}, Age: {willow.Age}");
}
```

可以看出：

- 存取器 `get` 和 `set` 可以同时存在。
- 存取器 `get` 的返回值类型为**该存取器所在的属性所对应的类型**；而存取器 `set` 的返回值类型为 `void`。
- 存取器 `set` 中提供一个关键字 `value`，用于表示要设置的值。

另外，可访问性修饰符可以用于存取器，以控制对存取器的访问权限。但是存取器的可访问性必须**低于或等于**属性本身的可访问性。详见[可访问性大小关系](#可访问性大小关系)。

例如：

```novasharp
public class Person
{
    private int age; // 私有字段

    public int Age // 公开的属性
    {
        get
        {
            return age; // 当读取属性时，返回私有字段 age 的值
        };

        private set // 仅在 Person 内部可写
        {
            age = value; // 当写入属性时，设置私有字段 age 的值
        };
    }

    public void CelebrateBirthday()
    {
        Age ++;
    }
}
```

对于**没有显式声明可访问性修饰符**的存取器，其可访问性默认**与对应属性的可访问性相同**。

##### 属性的隐藏字段

当属性的 `get` 存取器或者 `set` 存取器访问了 `field` 关键字时，编译器会自动为属性创建**仅该属性的存取器可见**的隐藏字段。这种隐藏字段不能被对象中其他任何成员访问。且隐藏字段的生命周期与所属对象一致，随对象销毁而回收。

例如：

```novasharp
public class Person
{
    public int Id  // 带隐藏字段的属性
    {
        get
        {
            return field;
        };

        private set
        {
            field = value;
        };
    }

    public int Age
    {
        get
        {
            return field;
        };

        set
        {
            field = value;
        };
    }
}
```

在属性中，可以使用 `field` 关键字来访问属性所对应的隐藏字段。

##### 存取器的简写形式

存取器 `get` 和 `set` 存在简写形式:

- 对于：

  ```novasharp
  get
  {
      return field;
  };
  ```

  可以直接用 `get` 代替。

- 对于：

  ```novasharp
  set
  {
      field = value;
  };
  ```

  可以直接用 `set` 代替。

例如：

```novasharp
public class Person
{
    public int Age { get; set; }
}
```

以上代码等价于:

```novasharp
public class Person
{
    public int Age
    {
        get
        {
            return field;
        };

        set
        {
            field = value;
        };
    }
}
```

##### 属性的隐藏字段与引用

在属性中，若需创建属性所对应的隐藏字段的引用，可以直接使用 `ref <属性名>` 的格式。

> [!IMPORTANT]
> 属性本身无法被引用，因为属性不存储数据。

#### 结构体

在 NovaSharp 中，结构体是一种值类型，用于封装一组相关字段。结构体可以包含字段、属性、方法，这些字段和方法是结构体的成员。

> [!IMPORTANT]
> 结构体允许包含构造函数，但**不能**包含析构函数或静态成员。

结构体的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] struct <结构体名>
{
    // 字段
    [<修饰符1>, <修饰符2>, ...] <类型>[] <变量名> [= <初始值>]；

    // 方法
    [<修饰符1>, <修饰符2>, ...] <返回值类型> <方法名>[<<泛型占位符列表>>](<参数列表>) [require <重载条件>]
    {
        // 方法体
    }
}
```

对于结构体中的字段与函数，若没有显式声明可访问性修饰符，则默认为 `private`。

样例如下:

```novasharp
public struct Point
{
    public int X;
    public int Y;

    public void Move(int dx, int dy)
    {
        X += dx;
        Y += dy;
    }
}
```

使用结构体时，可以直接创建其实例并访问其公开的成员。例如：

```novasharp
Point p;
p.X = 10;
p.Y = 20;
p.Move(5, 5);
```

#### 类

类是 NovaSharp 中用于封装字段与方法的基本构建块。类可以包含字段、属性、方法，这些字段和方法是类的成员。

类的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] class <类名>
{
    // 字段
    [<修饰符1>, <修饰符2>, ...] <类型> <字段名> [= <初始值>]；

    // 方法
    [<修饰符1>, <修饰符2>, ...] <返回值类型> <方法名>(<参数列表>)
    {
        // 方法体
    }
}
```

> [!IMPORTANT]
> 对于类中的成员，若没有显式声明可访问性修饰符，则默认为 `private`。

使用类时，可以通过创建其实例来访问其成员。例如：

```novasharp
public class Person
{
    public string Name;
    public int Age;

    public void Birthday()
    {
        Age ++;
    }
}

int Main()
{
    // 创建类的实例
    Person willow = new Person();
    willow.Name = "Willow";
    willow.Age = 15;
    willow.Birthday();
}
```

#### 构造函数与析构函数

构造函数是一种特殊类型的函数，用于初始化类的或者结构体的实例。构造函数的名称与类名相同，并且没有返回值。在 NovaSharp 中，构造函数可以有参数，也可以重载。

构造函数将在对象创建时被调用。

构造函数的定义格式如下：

```novasharp
public <类名>(<参数列表>)
{
    // 初始化代码
}
```

要创建对象实例，可以使用 `new` 语句调用构造函数，并传递所需的参数。格式如下：

```novasharp
new <对象名>(<构造函数参数列表>);
```

> [!IMPORTANT]
> 注意：`new` 语句返回的是一个引用。

析构函数是一种特殊类型的函数，用于清理类的实例。一般来说，它会被内存管理系统自动调用。在 NovaSharp 中，析构函数的名称与类名相同，但前面加上 `~` 符号，并且没有参数和返回值。

析构函数的调用时机详见[数据的生命周期](#数据的生命周期)。

析构函数的定义格式如下：

```novasharp
// 析构函数
public ~<类名>()
{
    // 清理代码
}
```

要手动清理类的实例，可以使用 `remove` 语句调用析构函数。格式如下：

```novasharp
remove <变量名>;
```

> [!IMPORTANT]
> 慎用 `remove` 语句，它可能导致未定义的行为。详见[数据的生命周期](#数据的生命周期)

构造函数与析构函数的样例如下:

```novasharp
public class Person
{
    public string Name;
    public int Age;

    public Person(string Name, int Age)
    {
        this.Name = Name;
        this.Age = Age;
    }

    public ~Person()
    {

    }
}

int Main()
{
    Person willow = new Person("Willow", 15);
    remove willow;
}
```

> [!IMPORTANT]
> 构造函数与析构函数的访问修饰符默认为 `public`，且它们**不能**被显式声明为 `static`。

#### 继承、虚函数与密封

在 NovaSharp 中，类可以通过继承来扩展其他类的功能。子类可以继承父类的字段和方法，并可以重写父类的方法以提供特定的实现。

继承的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] class <子类名> : <父类名>
{
    // 子类特有的成员
}
```

> [!IMPORTANT]
> NovaSharp 中的类只支持单继承，即一个类只能继承一个直接父类。而对于接口，NovaSharp 支持多重继承，即一个类可以实现多个接口。

显式声明了 `virtual` 的函数是虚函数。虚函数是允许在派生类中重写的函数。通过使用虚函数，基类可以提供默认实现，而派生类可以选择性地重写该实现。重写虚函数时，必须使用 `override` 关键字作为修饰符。

显式声明了 `sealed` 的类为密封类，不允许被继承。而对于显式声明了 `sealed` 的字段，不允许被实现或重写。

#### 接口

接口是一种引用类型，仅用于声明字段、属性与方法的契约，自身无法被实例化。类可以实现一个或多个接口，从而承诺提供接口中定义的成员。

接口的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] interface <接口名>
{
    // 方法
    <返回值类型> <方法名>(<参数列表>);

    // 字段
    <返回值类型> <字段名>;
}
```

> [!IMPORTANT]
> 对于接口中的成员，不需要、也不能声明可访问性修饰符。

实现接口时，类必须提供接口中所有成员的具体实现，且这些实现必须是 `public` 的。例如：

```novasharp
public interface IDrawable
{
    void Draw(int color);
    int PenWidth;
}

public class Circle : IDrawable
{
    public int PenWidth;
    public int Radius; // 自定义字段

    public void Draw(int color) // 必须实现 Draw(int color) 函数
    {
        // 绘制圆形
    }
}

public class Rectangle : IDrawable
{
    public int PenWidth;
    public int Width;
    public int Height;

    public void Draw(int color) // 必须实现 Draw(int color) 函数
    {
        // 绘制矩形
    }
}
```

此时，可以通过 `IDrawable` 接口来调用 `Circle` 实例和 `Rectangle` 实例的 `Draw` 方法：

```novasharp
IDrawable circle = new Circle();
IDrawable rectangle = new Rectangle();

circle.Draw(0xFF0000);
rectangle.Draw(0x00FF00);
```

#### 抽象类与派生类

抽象类是一种不可实例化的类，可包含抽象字段、抽象方法作为成员，这些方法在派生类中必须被实现。抽象类可以包含其他成员（字段、方法等），这些成员可以有具体的实现。

抽象类的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] abstract class <类名>
{
    // 字段
    [<修饰符1>, <修饰符2>, ...] <类型> <字段名> [= <初始值>]；

    // 方法
    [<修饰符1>, <修饰符2>, ...] abstract <返回值类型> <方法名>(<参数列表>);
}
```

> [!CAUTION]
> 对于抽象类中的成员，若没有显式声明可访问性修饰符，则默认为 `private`。

使用抽象类时，必须创建其派生类并实现所有抽象成员。例如：

```novasharp
public abstract class Shape
{
    public abstract void Draw();

    public virtual void Resize(double factor)
    {
        // 允许虚函数，子类可以选择性重写
    }
}

public class Circle : Shape
{
    public override void Draw()
    {
        // 绘制圆形
    }
}
```

#### 匿名实例

若需临时聚合数据而又不想显式声明类型，可使用匿名实例。匿名对象可以在创建时初始化其字段，并且可以在需要时传递。

匿名对象的定义格式如下：

```novasharp
new {
    [<修饰符1>, <修饰符2>, ...] <类型> <字段名> [= <初始值>]
    ...
}
```

使用时，编译器将对匿名实例生成具名类型。可用 `var` 关键字来接收这个具名类型的实例。例如：

```novasharp
var person = new {
    Name = "Willow",
    Age = 15
};
```

#### 实例方法的隐式 this

在 NovaSharp 中，对象的实例方法是指在对象内部定义的、没有声明 `static` 的函数。它也包括构造函数和析构函数，这些函数可以直接访问所属实例的字段和方法，并且可以被其他函数调用。举例：

```novasharp
public class Person
{
    public string Name;
    public int Age;

    public Person(string Name, int Age)
    {
        this.Name = Name;
        this.Age = Age;
    }

    public void CelebrateBirthday() // CelebrateBirthday() 是 Person 类的实例方法
    {
        Age++;
        Console.WriteLine($"Today is {Name}'s birthday! Now {Age} years old."); // 允许访问所属实例的 Name 字段
    }
}
```

在上述代码中，`Person` 的构造函数使用了看上去不存在的 `this` 变量。这种操作这是被允许的。实际上，对象的实例方法均隐藏了一个名为 `this` 的引用参数，指向当前对象的实例。因此，上述代码的本质是：

```novasharp
public class Person
{
    public string Name;
    public int Age;

    public static Person(ref Person this, string Name, int Age) // 构造函数不能被显式声明为静态，此处是为了方便理解。
    {
        this.Name = Name;
        this.Age = Age;
    }

    public static void CelebrateBirthday(ref Person this)
    {
        this.Age++;
        Console.WriteLine($"Today is {this.Name}'s birthday! Now {this.Age} years old.");
    }
}
```

#### 扩展函数

扩展函数是一种特殊类型的静态方法，它允许在不修改现有类的情况下，为其添加新功能。通过使用扩展函数，可以为类添加新的方法，而不需要创建派生类或修改原始类的代码。

扩展函数的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] static <返回值类型> <函数名>(this <类名> <参数名>, <其他参数>)
{
    // 函数体
}
```

使用扩展函数时，可以像调用实例方法一样调用它们。例如：

```novasharp
public static int WordCount(this string str)
{
    return str.Split(new[] { ' ', '\n', '\r' }).Length;
}

int Main()
{
    // 使用扩展函数
    string text = "Hello, world!";
    int count = text.WordCount();
}
```

#### 静态

静态成员属于类型本身，而非类型的任何实例，它们不依赖于特定实例的状态。静态成员在对象加载时创建，并在程序运行期间存在。它们可以通过对象名直接访问，而不需要创建对象的实例。要声明静态成员，可以使用 `static` 关键字。例如：

```novasharp
public class Counter
{
    public static int TotalCount = 0; // 静态成员，所有实例共享
    public int InstanceCount = 0; // 非静态成员，每个实例独有

    public void Increment()
    {
        TotalCount++; // 增加全局计数
        InstanceCount++; // 增加当前实例计数
    }
}

int Main()
{
    Counter a = new Counter();
    Counter b = new Counter();

    a.Increment();
    b.Increment();

    Console.WriteLine(Counter.TotalCount); // 输出: 2 （所有实例共享的静态成员）
    Console.WriteLine(a.InstanceCount); // 输出: 1 （a 实例的非静态成员）
    Console.WriteLine(b.InstanceCount); // 输出: 1 （b 实例的非静态成员）
}
```

上例中，`TotalCount` 是静态成员，所有 `Counter` 实例共享同一个值；而 `InstanceCount` 是非静态成员，每个实例有自己的独立值。

> [!IMPORTANT]
> 静态函数**无法访问实例成员（非静态成员）**，因为它们不依赖于特定实例的状态。

静态对象是不能被实例化的对象。例如：

```novasharp
public static class MathUtils
{
    public static int Add(int a, int b)
    {
        return a + b;
    }
}

// 调用静态函数
int result = MathUtils.Add(5, 3);
```

> [!IMPORTANT]
> 静态对象的所有成员都必须是静态的。

#### 索引器

索引器是一种特殊的属性，允许通过数组索引的方式访问对象的内部数据。在 NovaSharp 中，可以使用 `this` 关键字来定义索引。并使用 `get` 和 `set` 存取器来分别定义获取和设置值的逻辑。格式如下：

```novasharp
public <返回值类型> this[<参数列表>]
{
    get
    {
        <获取值的逻辑>
    };

    set
    {
        <设置值的逻辑>
    }
}
```

使用索引器时，可以像访问数组元素一样访问对象的内部数据。例如：

```novasharp
public class StringCollection
{
    private string[] strings;

    public StringCollection(string[] strings)
    {
        this.strings = strings;
    }

    // 定义索引器
    public string this[int index]
    {
        get
        {
            return strings[index];
        };

        set
        {
            strings[index] = value;
        };
    }
}

int Main()
{
    StringCollection collection = new StringCollection(new string[] { "Hello", "World" });
    Console.WriteLine(collection[0]); // 输出: Hello
    collection[1] = "NovaSharp";
    Console.WriteLine(collection[1]); // 输出: NovaSharp
}
```

#### 对象对 each 循环的隐式适配提示

若希望对象能够隐式适配 each 循环，请包含一个能够将对象隐式转换为数组的方法。

### 泛型

泛型是指在定义类、接口或方法时，不指定具体的数据类型，而是使用占位符（通常是 `T`）来表示类型。这样可以在使用时指定具体的类型，从而实现代码的重用和类型安全。

以泛型函数为例，泛型的基本语法如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] <返回值类型> <函数名><<泛型占位符1> [, <泛型占位符2>, <泛型占位符3>, ...]>(<参数列表>)
{
    // 函数体
}
```

泛型支持同时存在多个占位符。以泛型结构体为例：

```novasharp
public struct Pair<TKey, TValue>
{
    public TKey Key;
    public TValue Value;

    public Pair(TKey key, TValue value)
    {
        Key = key;
        Value = value;
    }
}
```

#### 泛型限制

允许使用 `where` 关键字对泛型类型参数进行约束，通过 `is` 关键字限制其类型。例如，可以限制泛型类型必须继承或派生自己某个基类，或者实现某个接口。

以泛型函数为例：

```novasharp
public class Entity
{

}

public T SetEntityData<T>(T target) where T is Entity
{
    // 函数体
}
```

允许针对多个泛型占位符加多个限制，以泛型类为例：

```novasharp
public class Repository<T, U> where T is Entity，U is IComparable
{
    public void Add(T entity)
    {
        // 添加实体
    }
}
```

对于函数而言，`where` 关键字还可以与 `require` 关键字结合使用，以指定更复杂的约束条件。

以如下代码为例，可读性角度出发，我们建议你采取这样的格式：

```novasharp
public T SetEntityData<T>(T target, string name)
    where T is Entity
    require name != null && name.Length > 0
{
    target.Name = name;
    target.UpdatedAt = DateTime.Now;
    return target;
}
```

### 委托

委托是一种引用类型，是“存储函数的变量”，用于封装方法的调用。委托可以像变量一样传递，并可以指向任何具有相同参数列表和返回值类型的方法。通过使用委托，可以实现事件处理、回调等功能。

在 NovaSharp 中，委托的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] delegate <返回值类型> <委托名>(<参数列表>);
```

使用委托时，可以通过创建其实例并将其指向具体的方法。例如：

```novasharp
public delegate int MathOperation(int a, int b);

public class Calculator
{
    public int Add(int a, int b)
    {
        return a + b;
    }

    public int Subtract(int a, int b)
    {
        return a - b;
    }
}

// 使用委托
MathOperation op = new Calculator().Add;
int result = op(5, 3);
```

### 协程

协程（Coroutine）是一种特殊的函数，它允许在执行过程中挂起和恢复，用于实现异步、延迟或分步执行的逻辑。

可以使用 `coroutine` 关键字声明协程函数。例如：

```novasharp
public coroutine bool DownloadFile(string url)
{
    // 下载前的准备
    yield;
    // 执行下载
    yield;
    // 下载完成
}
```

协程函数可以包含 `yield` 语句，用于挂起当前执行并保存状态，稍后可恢复。

NovaSharp 的协程在编译时会被自动转换为状态机。状态机的本质是类。编译器会将协程函数拆分为多个状态，每个 `yield` 语句对应一个状态切换点。这样可以在每次恢复协程时，从上次挂起的位置继续执行。

对协程函数的调用会返回一个协程对象。可以通过调度器或手动控制协程的执行和恢复。例如：

```novasharp
coroutine bool DownloadFileTask = DownloadFile("https://example.com");
DownloadFileTask.Resume(); // 恢复到下一个 yield
```

在以上例子中，DownloadFileTask 是一个 `coroutine bool` 类型的变量，也就是说，[变量](#变量)章节所规定的内容仍然适用于它。同时，DownloadFileTask 可以被隐式转换为 `bool`。

> [!TIP]
> 协程仍然在调用该协程的线程中执行。因此，为防止进程卡死，在循环或耗时的操作中应适当使用 `yield` 语句。

### Lambda

Lambda 表达式是一种简洁的表示匿名函数的方式。它可以用来创建委托或表达式树。Lambda 表达式的基本语法如下：

```novasharp
(<参数类型1> <参数名1>, <参数类型2> <参数名2>, ...) => <语句或代码块>
```

> [!TIP]
> 在参数类型可被推导时，可以省略参数类型。

样例如下：

```novasharp
(int a, int b) => a + b;

delegate Add(int a, int b) = (x, y) => x + y;
```

#### 使用 Lambda 简化函数声明

Lambda 提供了一种简化函数声明的方式，它的语法如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] <返回值类型> <函数名>(<参数列表>) => <语句>;
```

因此，以下代码：

```novasharp
public int Add(int a, int b)
{
    return a + b;
}
```

可以被简写为：

```novasharp
public int Add(int a, int b) => a + b;
```

#### 使用 Lambda 简化存取器声明

Lambda 提供了一种简化存取器声明的方式。以 `get` 存取器为例，它的语法如下：

```novasharp
get => <语句>
```

因此，以下代码：

```novasharp
public class Person
{
    private int age;

    public int Age
    {
        get
        {
            return age;
        }

        set
        {
            age = value;
        }
    }
}
```

可以被简化为：

```novasharp
public class Person
{
    private int age;

    public int Age
    {
        get => age;
        set => age = value;
    }
}
```

#### Lambda 的返回值

Lambda 表达式的返回值由表达式的结果决定。分两种情况：

1. 如果 Lambda 表达式的 `=>` 符号后面是一条语句，则该语句的值就是返回值。
2. 如果 Lambda 表达式的 `=>` 符号后面是一个代码块，则需要使用 `return` 语句显式指定返回值。

### 命名空间

命名空间是一种用于组织代码的方式，可以将相关的类、结构体、接口、函数等成员进行分组，以避免名称冲突。在 NovaSharp 中，命名空间的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] namespace <命名空间名>
{
    // 成员定义
}
```

使用命名空间时，可以通过 `using` 指令来引入其他命名空间，从而简化代码中的类型引用。例如：

```novasharp
using Standard.IO;

namespace PersonData
{
    public class Person
    {
        public string Name;
        public int Age;

        public void CelebrateBirthday()
        {
            Age++;
        }
    }

    // 与 C# 不同，NovaSharp 允许函数出现在类、结构体、接口等的外部，被直接包含到命名空间中
    public void PrintPersonData(Person person)
    {
        Console.WriteLine($"Name: {person.Name}, Age: {person.Age}");
    }
}
```

当需要引入一个命名空间下的所有子命名空间时，可以使用 `using` 指令的 `*` 通配符。例如：

```novasharp
using Standard.*;

public void Main()
{
    Console.WriteLine("Hello, World!"); // 来自命名空间 Standard.IO 的 Console 类
}
```

NovaSharp 允许**在所有命名空间之外**定义函数、变量或对象，这些成员将**不属于任何命名空间**，并**可以在全局范围内被访问**。

### 异常处理

当程序运行时发生错误或异常情况时，可以使用异常处理机制来**捕获**和**处理**这些异常。在 NovaSharp 中，异常处理使用 `try`、`catch` 和 `finally` 语句块来实现。其中，`finally` 块可以被省略。

异常处理的基本结构如下：

```novasharp
try
{
    // 可能引发异常的代码
}
catch <异常类型> <变量名>
{
    // 处理异常的代码
}
finally
{
    // 无论是否发生异常，都会执行的代码
}
```

在 `try` 块中放置**可能引发异常的代码**。如果发生异常，程序会**立即跳转**到对应的 `catch` 块进行处理。`finally` 块中的代码**无论是否发生异常都会执行**，通常用于释放资源或执行清理操作。

异常类型是**一种专门用来处理异常信息**的**类**。其中，`Exception` 是所有异常的基类，可以用于捕获所有类型的异常。

```novasharp
public void Main()
{
    try
    {
        int result = Divide(10, 0);
        Console.WriteLine(result);
    }
    catch DivideByZeroException e
    {
        Console.WriteLine("Error: Division by zero is not allowed.");
    }
    catch Exception e // 通过堆叠 catch 块来处理不同类型的异常
    {
        Console.WriteLine("Error: Unknown exception occurred.");
    }
    finally
    {
        Console.WriteLine("Cleanup code can go here.");
    }
}

public static int Divide(int a, int b)
{
    return a / b;
}
```

在上面的例子中，`Divide` 方法尝试进行除法运算，如果除数为零，则会引发 `DivideByZeroException`。在 `catch` 块中捕获该异常并输出错误信息，`finally` 块中的代码始终会执行。

> [!IMPORTANT]
> 注意：`finally` 块中禁止 `return`。

#### 抛出异常

在 NovaSharp 中，可以使用 `throw` 关键字来手动抛出异常。抛出异常的基本语法如下：

```novasharp
throw <异常对象>;
```

例如，要抛出一个 `DivideByZeroException`，可以这样写：

```novasharp
if (b == 0)
{
    throw new DivideByZeroException("Division by zero is not allowed."); // 创建一个名为 DivideByZeroException 的异常对象
}
```

#### `Exception` 类实现

`Exception` 类的实现如下:

```novasharp
public class Exception
{
    public readonly string Message;
    public readonly Exception? InnerException;

    public Exception(string message, Exception? innerException = null)
    {
        Message = message;
        InnerException = innerException;
    }
}
```

#### 内置的异常类型

在 NovaSharp 中，内置的异常类型主要包括以下几种：

| 名称                                 | 描述                                                     |
| ------------------------------------ | -------------------------------------------------------- |
| `NullReferenceException`             | 当尝试访问一个为 `null` 的对象时引发。                   |
| `DivideByZeroException`              | 当尝试进行零除法运算时引发。                             |
| `IndexOutOfRangeException`           | 当访问数组或集合时使用了无效的索引时引发。               |
| `InvalidOperationException`          | 当对象处于不适合执行操作的状态时引发。                   |
| `ArgumentException`                  | 当方法接收到一个无效的参数时引发。                       |
| `NotImplementedException`            | 当方法尚未实现时引发。                                   |
| `NoMatchingFunctionException`        | 当没有找到匹配的函数时引发。                             |
| `InvalidIndexUnitReferenceException` | 当尝试访问的变量所持有的索引单元不存在或已被回收时引发。 |

### `penetrated` 修饰符

`penetrated` 修饰符用于指示变量或临时变量绕过对象索引表机制，直接存储到内存中。也算是 NovaSharp 的一大特色。

有关对象索引表机制的内容，详见[对象索引表与索引单元](#对象索引表与索引单元)。

当一个变量被声明 `penetrated` 时，它将绕过对象索引表机制，直接存储到内存中。这意味着对该变量的访问将不再通过索引单元，而是直接访问其在内存中的位置。

声明了 `penetrated` 的变量**无法被引用**。原理详见[引用](#引用)。

> [!IMPORTANT]
> 修饰符 `penetrated` 仅适用于变量或临时变量，不能用于类、结构体、接口的成员。且**必须被显式声明**。

### 编译器指令

NovaSharp 提供了一些编译器指令，用于控制编译过程中的行为。这些指令以 `#` 开头，通常放置在文件的顶部。

以下是 NovaSharp 支持的编译器指令：

| 指令      | 描述                                                                                  |
| --------- | ------------------------------------------------------------------------------------- |
| `#define` | 定义一个符号，可以在代码中使用 `#if`、`#elif`、`#else` 和 `#endif` 指令进行条件编译。 |
| `#undef`  | 取消定义一个符号。                                                                    |
| `#if`     | 开始一个条件编译块，只有在定义了指定的符号时，块中的代码才会被编译。                  |
| `#elif`   | 在 `#if` 块中添加一个新的条件。                                                       |
| `#else`   | 在 `#if` 块中添加一个默认的条件。                                                     |
| `#endif`  | 结束一个条件编译块。                                                                  |

所有的编译器指令仅在当前文件中生效，且效果仅作用于该指令之后的每一行。

例如以下代码：

```novasharp
using Standard.*

// 定义了Debug
#define DEBUG

public int Main()
{
    #if DEBUG
    // 如果定义了 DEBUG，执行以下代码
    Console.WriteLine("Debug mode is enabled."); // 由于定义了 DEBUG，此时被编译并执行，输出
    #else
    // 如果未定义 DEBUG，执行以下代码
    Console.WriteLine("Debug mode is disabled."); // 此时不会被编译并执行，不会输出
    #endif

    // 取消定义 DEBUG，影响后面的所有代码
    #undef DEBUG

    #if DEBUG
    // 如果定义了 DEBUG，执行以下代码
    Console.WriteLine("Debug mode is enabled."); // 此时不会被编译并执行，不会输出
    #else
    // 如果未定义 DEBUG，执行以下代码
    Console.WriteLine("Debug mode is disabled."); // 由于 DEBUG 被取消定义，此时被编译并执行，输出
    #endif
}
```

## 主函数

在 NovaSharp 中，程序的执行入口是 `Main` 函数。每个 NovaSharp 程序必须包含一个 `Main` 函数，作为程序的起始点。

`Main` 函数的基本结构如下：

```novasharp
public int Main()
{
    // 程序的入口点
    return 0;
}
```

> [!IMPORTANT]
> 请注意：`Main` 函数不应当属于任何对象或命名空间。

主函数的 `return 0;` 表示程序正常结束，可以省略，编译期自动补上。

## 内存管理

> [!NOTE]
> 本章节中我们讨论的“对象”是指在内存中分配的实例，包括基本类型、结构体、类等。

NovaSharp 使用半自动内存管理模型，它包含**对象索引表**和**数据存储池**两大内存空间。

重申：NovaSharp 不依赖于运行时。这意味着不可能仿照传统的 C# 的 GC 机制。

内存管理的实现细节**由编译器决定**。

### 数据存储池

数据存储池是一块堆内存，它用于存放对象的实际数据。

为了方便可能的多语言、多系统协同场景需求，数据存储池内的对象存储布局应当符合通用的布局方式。

### 对象索引表与索引单元

对象索引表的基本单位是索引单元，索引单元用于存储对象的指针、引用计数等信息。

这是索引单元模型：

```novasharp
public struct IndexUnit<TObject>
{
    public TObject* ObjectPointer;
    public uint ReferenceCount;
}
```

> [!TIP]
> 以上只是索引单元的理想模型。实际上的索引单元在内存上可能会更加紧凑，并可能存储更多的数据以进行访问效率等方面的优化。

对于每一个对象，都可以在对象索引表中找到对应的索引单元。

这么设计可以辅助定位和管理对象并高效处理对象引用，为内存管理提供支持。

> [!TIP]
> NovaSharp 中，存在以下**编译时可选项**：
>
> - 让**对引用计数的操作**均采用**原子操作**以确保线程安全。
>
> 该选项**默认开启**。

#### 索引单元、变量与数据之间的关系

变量（指针类型的变量除外）本身并不存储对象，而是**持有**索引单元。但是，本规范中有特殊规定的除外。

对象被存储在数据存储池中，索引单元则存储指向对象的指针与引用计数。

一个索引单元允许被多个变量**持有**。索引单元的引用计数用于跟踪持有该索引单元的变量数量，当：

- **有新的变量持有**该索引单元时，引用计数加 1。
- 有持有该索引单元的变量**被销毁时**，引用计数减 1。
- 引用计数为**归零**时，索引单元将被回收，其对应的数据也会被回收。

#### 引用的本质

引用本质上传递了一个索引单元。当引用作为变量的初始值时，它持有的就是该引用所传递的索引单元。

#### 对指针的特殊处理与取地址相关规定

指针类型的变量将绕过对象索引表直接指向数据。因此禁止将引用传递给指针。

使用取地址符号进行取地址操作时：

| 操作目标                         | 实际获取的地址                       |
| -------------------------------- | ------------------------------------ |
| 非指针类型变量                   | 变量持有的索引单元所指向的数据地址   |
| 指针类型变量                     | 指针变量自身的内存地址               |
| 声明了 `penetrated` 修饰符的变量 | 变量的数据在内存中的地址             |
| 引用                             | 引用所传递的索引单元所指向的数据地址 |

例如：

```novasharp
int a = 1;
int b = ref a;
int* p1 = &b; // 合法，这里获取了变量 b 持有的索引单元所指向的数据地址
int* p2 = ref b; // 报错，引用所传递的是对索引单元，指针类型的变量不能持有索引单元
int* p3 = &ref b; // 合法，这里获取了对变量 b 的引用所传递的索引单元所指向的数据地址
```

### 数据的生命周期

在 NovaSharp 中，数据的生命周期由其所对应的索引单元的引用计数决定，与变量分离，与作用域无直接关联。当一个对象被创建时，其引用计数为 1；当有新的引用指向该对象时，引用计数会增加；当引用被销毁时，引用计数会减少。当引用计数为 0 时，对象会被回收。

下面给出一个简单的场景：

```novasharp
public int[] CreateRange(int start, int end)
{
    int[] result = new int[end - start];
    for int i = 0; i < result.Length; i++
    {
        result[i] = start + i;
    }
    return result;
}

public int Main()
{
    int[] range = ref CreateRange(1, 5);
}
```

让我们就这个例子进行简要分析：

1. 调用了函数 `CreateRange(1, 5)`
2. `new int[4]` 创建了一个大小为 4 的 `int` 类型数组，并将其放入数据存储池中，创建对应的索引单元（此处用 IU 表示）。
3. `result` 被创建，并持有 IU，**IU 的引用计数加 1**。
4. `result` 作为返回值被返回，**IU 的引用计数加 1**。
5. `result` 离开作用域被销毁，**IU 的引用计数减 1**。
6. `range` 被创建，并持有 IU，**IU 的引用计数加 1**。
7. `CreateRange(1, 5)` 的返回值所在的语句结束，**IU 的引用计数减 1**。
8. `range` 离开作用域（`Main` 函数退出）被销毁，**IU 的引用计数减 1**。
9. 由于 IU 的引用计数归零，IU 所指向的对象将被回收，IU 被回收。

> [!TIP]
> 当对象被回收前，会**自动调用其析构函数**（如有定义）。析构函数相关内容详见[构造函数与析构函数](#构造函数与析构函数)。

#### `remove` 语句和 `delete` 语句的区别与本质

`delete` 语句用于手动销毁变量。但不一定回收所对应的数据，也不一定回收数据对应的索引单元。

当执行 `delete` 语句时：

1. 获取变量持有的索引单元。
2. 将索引单元的引用计数减 1。
3. 判断引用计数是否为 0，如果是，则回收索引单元及其对应的数据，否则保留索引单元及其对应的数据。
4. 销毁变量。

相对应的，`remove` 语句用于手动销毁变量并**强制回收**变量所对应的数据，并回收数据对应的索引单元。

当执行 `remove` 语句时：

1. 获取变量持有的索引单元。
2. 回收索引单元及其对应的数据。（相当于将索引单元的引用计数归零）
3. 销毁变量。（相当于 `delete` 语句）

此时，如果有别的持有相同索引单元的变量，当尝试访问这些变量时，由于它们所持有的索引单元已被回收，则会引发 `InvalidIndexUnitReferenceException` 异常。

### 临时对象存储优化

编译器可依据逃逸分析，将作用域局限在函数内的对象直接分配在栈上，无需索引单元。

## 项目

NovaSharp 将多份代码整合为一个项目，由项目配置文件在组织。

项目配置文件是一个 JSON 格式的文件，其扩展名为 `.nsproj`，用于描述项目的基本信息和依赖关系。它被存储在**项目根目录**。

配置字段表格如下：

| 字段名         | 类型   | 必填 | 说明           |
| -------------- | ------ | ---- | -------------- |
| `project`      | string | 是   | 项目唯一标识符 |
| `version`      | string | 否   | 语义化版本号   |
| `dependencies` | list   | 否   | 依赖项         |

以下是一个简单的项目配置文件示例：

```json
{
  "project": "MyProject",
  "version": "1.0.0",
  "dependencies": ["../AnotherProject/AnotherProject.nsproj", "Standard"]
}
```

### 依赖项

项目配置文件中的 `dependencies` 字段用于指定项目的依赖项。

依赖项可以是：

1. 其他项目的相对路径，例如 `"../AnotherProject/AnotherProject.nsproj"`
2. 标准库的名称，例如 `"Standard"`

`dependencies` 字段中提到的所有依赖项均会被引入该项目配置文件所对应的项目中。此后允许在代码中访问依赖项的相关内容。

依赖项将在编译阶段被解析和处理。
