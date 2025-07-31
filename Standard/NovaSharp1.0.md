# NovaSharp 1.0 语言标准

NovaSharp 是一种同时支持面向对象和函数式编程的编程语言。

## 命名规范

对于 NovaSharp 代码文件，应当采用 `.ns` 作为后缀名。

对于以下内容，推荐采用对应的命名法则：

| 类别            | 命名法则    | 示例                                    |
| --------------- | ----------- | --------------------------------------- |
| 局部变量        | camelCase   | `itemCount`                             |
| 全局变量        | PascalCase  | `CacheSize`                             |
| 常量            | SNAKE_CASE  | `INT_MAX`                               |
| 类 / 结构体     | PascalCase  | `Account`                               |
| 枚举 / 枚举成员 | PascalCase  | `ComponentActivity`                     |
| 接口            | IPascalCase | `IComponent`（包含 I 前缀）             |
| 方法 / 函数     | PascalCase  | `GetAccountById`                        |
| 泛型            | TPascalCase | `T`（更为常用），`TItem`（包含 T 前缀） |

> [!TIP]
> 命名规范中提到的**局部变量**是指**在函数内部定义的变量**或者**对象的私有字段**。

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

### 注释

NovaSharp 中的注释分为单行注释和多行注释两种形式。

- 单行注释以 `//` 开头，直到行末结束。
- 多行注释以 `/*` 开始，以 `*/` 结束，可以跨越多行。

### 变量声明

NovaSharp 中的变量声明分为**显式类型声明**和**隐式类型推断**两种方式。

变量声明语句采用 `[<修饰符1>, <修饰符2>, ...] <类型> <变量1名称> [= <变量1初始值>] [, <变量2名称> [= <变量2初始值>], ...]` 的形式。对于隐式类型推断，其 `<类型>` 为 `var`，且**必须提供初始值**，编译器会根据初始值的类型进行推断。样例如下：

```novasharp
int explicitType1 = 1, explicitType2;  // 显式类型声明，此处创建了多个变量，其中，explicitType1 的初始值为 1
var implicitType = 'a';  // 隐式类型推断（此处编译器推断为 char）
public int PublicProperty;  // 带修饰符的类型声明
```

### 类型、基本类型与可空类型

NovaSharp 中的类型分为如下几类：

- 基本类型：包括 `int`、`float`、`double`、`char`、`bool` 等。
- 复合类型：包括数组、结构体、类等。
- 引用类型：包括接口、委托等。

其中，基本类型如下表所示：

| 类型     | 解释                        |
| -------- | --------------------------- |
| `short`  | 2 字节整数                  |
| `ushort` | 2 字节**无符号**整数        |
| `int`    | 4 字节整数                  |
| `uint`   | 4 字节**无符号**整数        |
| `long`   | 8 字节整数                  |
| `ulong`  | 8 字节**无符号**整数        |
| `huge`   | 16 字节整数                 |
| `uhuge`  | 16 字节**无符号**整数       |
| `float`  | 4 字节浮点数                |
| `double` | 8 字节浮点数                |
| `char`   | 2 字节字符                  |
| `bool`   | 1 字节布尔                  |
| `object` | 对象 (所有的类型均派生于此) |
| `void`   | 空类型                      |

#### 元组

元组是一种可用于存储多个不同类型数据项的复合类型，适合在无需专门定义结构体或类的场景下，将多个相关值组合在一起。

在 NovaSharp 中，元组作为类型时的声明格式为 `(<类型1> [<类型名1>], <类型2> [<类型名2>], ...)`，作为值或参数时的声明格式为 `([<值名称1>:] <值1>, [<值名称2>:] <值2>, ...)`，元组的元素数量和类型在声明时确定，声明后不可更改。

元组的定义与初始化示例：

```novasharp
(string, int) person = ("Alice", 30);  // 显式声明类型
(string Name, int Age) person = ("Alice", 30);
var info = ("Bob", 25, true);          // 隐式类型推断
var info = (Name: "Bob", Age: 25, IsStudent: true);
```

元组中未声明类型名的元素可通过 `.Item1`、`.Item2` 等属性访问，属性名按元素顺序自动生成。例如：

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

请注意，解构变量类型需与元组元素类型兼容。

元组可被嵌套使用：

```novasharp
var nested = (Name: "Eve", Info: (Age: 20, Score: 95));
Console.WriteLine(nested.Info.Score); // 输出: 95
```

#### 可空类型

可空类型是指可以赋值为 `null` 的值类型。在 NovaSharp 中，所有值类型都可以被声明为可空类型。

要声明一个可空类型，可以在类型后面使用 `?` 后缀。例如：

```novasharp
int? nullableInt = null;         // 可空整型
```

### 修饰符

NovaSharp 中的修饰符用于控制类、结构体、函数、变量等的可见性和行为。

| 修饰符      | 解释   | 特性                                                                                                                                |
| ----------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| `public`    | 公有   | （可访问性修饰符）可以在**对象之外**被访问                                                                                          |
| `private`   | 私有   | （可访问性修饰符）只能在**对象内部**被访问                                                                                          |
| `protected` | 受保护 | （可访问性修饰符）只能在**对象内部**或**派生类**中被访问                                                                            |
| `internal`  | 内部   | （可访问性修饰符）只能在**同一程序集**内被访问                                                                                      |
| `penetrate` | 穿透   | （可访问性修饰符，仅对于变量）在**对象，部**与**外部程序集**被视为只读，在**对象内部**可读写；（对于 `break` 语句）用于跳出所有循环 |
| `static`    | 静态   | 属于**对象**而非其实例                                                                                                              |
| `readonly`  | 只读   | （仅对于变量）只能在**初始化时**或者**构造函数**中被赋值                                                                            |
| `const`     | 常量   | 只能在**初始化时**被赋值                                                                                                            |
| `volatile`  | 易变   | 不被编译器优化                                                                                                                      |
| `abstract`  | 抽象   | （仅对于类）该成员在派生类中必须被重写                                                                                              |
| `sealed`    | 密封   | （仅对于类或其成员）该对象不能被继承或重写                                                                                          |
| `virtual`   | 虚拟   | （仅对于类中的函数）该成员可以在派生类中被重写                                                                                      |
| `override`  | 重写   | （仅对于类中的虚函数）允许在派生类中重新定义基类中的成员                                                                            |

对于所有的可访问性修饰符，它们的可访问性大小关系如下：

```
public > penetrate > protected > internal > private
```

### 赋值语句

赋值语句用于将变量的值设置为另一个值。

其基本语法为 `<变量名> = <值>`。在赋值时，变量的类型必须与赋值的值的类型兼容。

### 数组

数组是同一类型元素的集合，可以通过索引访问每个元素。数组的大小**在创建时确定**，不能动态改变。其索引**从 0 开始**。

数组本质上是**一块连续的内存区域**的**指针**，允许通过偏移量（索引）来访问每个元素。

创建数组实例的方式有如下两种：

1. 使用 `new` 关键字，通过 `new <类型>[<数量>]` 语句，显式创建一个大小为 `<数量>` 的数组实例。
2. 使用数组表达式。

#### 数组表达式

数组表达式格式为 `{ <元素1>, <元素2>, ... }`，代表数组中的若干个元素，可以被隐式转换为数组。若将一个元素数量为 `n` 的数组表达式赋值给数组，则代表将该数组表达式的元素的前 `n` 个元素按照顺序从 0 号索引逐一赋值给目标数组，如果发生越界，将会抛出异常。允许使用数组表达式初始化数组。

#### 声明数组

数组声明语句采用 `[<修饰符1>, <修饰符2>, ...] <类型>[] <变量名> [= <初始值>]` 的形式。样例如下：

```novasharp
int[] numbers;  // 声明一个整型数组
int[] numbers = new int[10];  // 声明并初始化一个整型数组
int[] numbers = { 1, 2, 3, 4, 5 };  // 使用数组表达式初始化一个大小为 5 的数组
```

### 运算与表达式

在 NovaSharp 中，运算符用于执行各种操作，包括**算术运算**、**比较运算**和**逻辑运算**等。运算符可以与**操作数结合**形成**表达式**，表达式的值可以用于**赋值**、**条件判断**等场景。

#### 运算符

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

其中，优先级越高的运算符**先被计算**，优先级相同的运算符会**按照从左到右的顺序**计算。允许使用小括号来改变运算顺序，使其中的表达式优先级最高，例如 `(a + b) * c` 中，`(a + b)` 会先被计算，从而影响计算结果。

#### 运算符重载

运算符的本质是一种特殊的函数，允许通过运算符重载来定义或修改该函数的行为。

在 NovaSharp 中，可以为自定义类型重载常见的运算符，例如 `+`、`-`、`*`、`/` 等，以实现更直观的操作。

运算符重载的格式如下：

```
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

请注意，运算符重载只能在结构体或类内部定义。运算符重载的修饰符固定为 `public static`，不能也不需要为运算符重载指定修饰符。

#### 表达式

表达式是由操作数和运算符组成的式子，可以计算出一个值。这个值类型由其操作数和运算符决定。表达式可以是简单的，也可以是复杂的。

- 简单表达式：由单个操作数构成，例如 `5`、`x`。
- 复杂表达式：由多个操作数和运算符构成，例如 `a + b * c`。

```novasharp
int a = 5;
int b = 10;
int c = a + b * 15;  // 复杂表达式
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

### 流程控制

NovaSharp 提供了多种流程控制语句，用于控制程序的执行流程，包括条件语句、循环语句等。

流程控制语句的结尾不需要分号。

#### 条件语句

条件语句用于根据条件的真假来决定执行不同的代码块。NovaSharp 中的条件语句包括 `if` 和 `else`，它们的基本语法为 `if <条件> <语句或代码块> [else <语句或代码块>]`。其中，`<条件>` 是一个布尔类型的表达式，常见的使用方法如下：

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

#### 循环语句

循环语句用于重复执行循环体（即重复执行同一语句或代码块），直到满足特定条件为止。NovaSharp 中的循环语句包括 `while` 循环、`do while` 循环、 `for` 循环和 `each` 循环。

其中：

- `while` 循环：在**条件为真**时重复执行循环体。其格式为 `while <条件> <循环体>`。

  样例如下:

  ```novasharp
  // while 循环
  while condition
  {
      doSomething();  // 当条件为真时重复执行的代码
  }
  ```

- `do while` 循环：**先执行循环体**，再判断条件是否为真。其格式为 `do <循环体> while <条件>`。

  样例如下:

  ```novasharp
  do
  {
      doSomething(); // 循环体
  } while (condition);
  ```

- `for` 循环：通过**对循环变量进行操作**来控制循环——**执行前**运行初始化语句，当**条件为真**时执行循环体，每次**执行循环体后**运行更新语句。

  - 对于循环体是**语句**的情况，其格式为 `for <初始化>; <条件>; <更新>; <循环体-语句>`；

    样例如下:

    ```novasharp
    for int i = 0; i < 10; i ++;  // 循环体是语句
        doSomething();
    ```

  - 对于循环体是**代码块**的情况，其格式为 `for <初始化>; <条件>; <更新>[;] <循环体-代码块>`。

    样例如下:

    ```novasharp
    for int i = 0; i < 10; i++    // 循环体是代码块
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

  // 以上代码等价于

  each i in numbers
  {
      doSomethingWith(i);
  }
  ```

#### 模式匹配语句

模式匹配语句用于根据数据内容来选择不同的执行路径。它的基本语法如下：

```
match <值>
{
    case <模式1>: <结果1>
    case <模式2>: <结果2>
    ...
    [default: <默认结果>]
}
```

其中，`<值>` 是要匹配的值，`<模式>` 是用来匹配的模式，`<结果>` 是匹配成功后要执行的语句或代码块，`<默认结果>` 则是所有模式都不匹配时要执行的语句或代码块，`<结果>` 为非代码块语句，则末尾需要分号。

此处所讲的模式，是 `<值> <逻辑运算符> <目标值>` 格式的、末尾没有分号的语句。不同的是，该语句开头的 `<值>` 被 `case` 所替代。

样例如下:

```novasharp
int result = 2;

match result
{
    case == 1:
        doSomethingWithOne();
        break;  // 跳出 match 语句
    case < 3:
        doSomethingWhenLessThanThree();
        break;
    default:
        doSomethingWithUnknown();
}
```

请注意，每个 `case` 必须包含 `break` 语句。因此，以上代码基本等价于:

```novasharp
int result = 2;

bool flag = false;

if result == 1
{
    doSomethingWithOne();
}
else if result < 3
{
    doSomethingWhenLessThanThree();
}
else
{
    doSomethingWithUnknown();
}

```

#### `break` 和 `continue` 语句

`break` 语句用于立即终止循环或 `match` 语句的执行，并跳出当前代码块。`continue` 语句用于跳过当前循环的剩余部分或当前 `case` 的剩余部分，直接进入下一次循环。

请注意，`break` 和 `continue` 语句只能作用于其所在的循环或 `match` 语句，不会在嵌套结构中的外层循环或外层 `match` 语句中生效。

样例如下:

```novasharp
while condition
{
    if someCondition
    {
        break;  // 跳出循环
    }
    if anotherCondition
    {
        continue;  // 跳过当前循环，进入下一次循环
    }
}
```

若希望将 `break` 语句作用于嵌套结构中的所有循环，可以在其前方加上 `penetrate` 关键字，但是该语法不适用于 `match`，例如：

```novasharp
while condition1
{
    while condition2
    {
        if someCondition
        {
            penetrate break;  // 跳出所有嵌套循环
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
    return a + b;   // 计算 a 和 b 的和
}

// 函数调用
int result = Add(5, 10);    // 调用 Add 函数，当传入的参数为 5 和 10 时，返回值为 15
```

若希望某些形式参数在调用时可以省略，可以为这些参数提供默认值。默认值的语法为`<参数名> = <默认值>`，并放在参数列表的末尾。

样例如下:

```novasharp
// 函数定义
int Add(int a, int b = 0)
{
    return a + b;   // 计算 a 和 b 的和
}

// 函数调用
int result1 = Add(5, 10);    // 调用 Add 函数，传入 5 和 10，返回值为 15
int result2 = Add(5);         // 调用 Add 函数，传入 5，返回值为 5
```

#### `return` 语句

`return` 语句用于结束函数的执行，并返回一个值给调用者当作该函数的返回值。其基本语法为 `return <返回值>;`。

请注意，`return` 语句只能出现在函数内部，且必须与函数的返回值类型匹配。且函数的任何执行路径都必须返回一个值。

对于返回值类型为 `void` 的函数，`return` 语句可以省略。若希望在某些情况下提前结束函数的执行，可以直接使用 `return;` 语句而不用携带返回值。

#### 函数重载

函数重载是指在同一个作用域内，可以定义多个**同名但参数列表不同**的函数，同时，不强制要求它们的返回值类型是否相同。编译器会根据函数调用时传入的参数类型和数量来决定调用哪个具体的函数。

以下是一个函数重载的示例：

```novasharp
// 函数定义
int Add(int a, int b)
{
    return a + b;   // 计算 a 和 b 的和
}

double Add(double a, double b)
{
    return a + b;   // 计算 a 和 b 的和
}

// 函数调用
int result1 = Add(5, 10);    // 调用第一个 Add 函数，返回值为 15
double result2 = Add(5.5, 10.5); // 调用第二个 Add 函数，返回值为 16.0
```

#### 带条件的重载

若对于同名但参数列表不同的函数，希望根据特定条件来选择调用哪个函数，可以使用 `require` 语句来实现。使用`require` 语句的函数定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] <返回值类型> <函数名>(<参数列表>) require <条件1>[, <条件2>, <条件3>, ...]
{
    // 函数体
}
```

这些条件可以是任意的布尔表达式，用于限制函数的调用。每个条件之间由逗号隔开。

例如：

```novasharp
void process(int type, int value) require type == 1
{
    // 处理 type == 1 时的情况
}

void process(int type, int value) require type == 2, value < 5
{
    // 处理 type == 2 且 value < 5 时的情况
}

void process(int type, int value)
{
    // 处理其它情况
}
```

请注意，调用操作将按照声明顺序从上到下匹配函数，带 `require` 语句的函数会被优先匹配。必须声明一个不带 `require` 语句的同名函数以应对其它情况。

#### 引用与输出值

在 NovaSharp 中，可以通过引用参数和输出参数来实现函数的输入输出。

引用参数：在函数参数前加上 `ref` 关键字，表示该参数是引用传递。函数内部对该参数的修改会影响到外部变量。

样例如下:

```novasharp
void UpdateValue(ref int value)
{
    value += 10;
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

请注意，输出参数必须在函数内部被赋值。在调用带有输出参数的函数时，必须使用 `out` 关键字来接收返回值。

样例如下:

```novasharp
int a, b, result;

Add(a, b, out result);
```

以上内容可被简写为

```novasharp
int a, b;

Add(a, b, out int result);  // 变量 result 在此处定义
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

请注意，每一个枚举值所对应的整数**不允许重复**。若不提供对应的整数，则默认从 0 开始依次递增，若出现冲突，则后面的枚举值会自动加 1 直至冲突避免。

样例如下:

```novasharp
public enum Color
{
    Red,    // 对应值默认为 0
    Green = 2,  // 原对应值为 1，由于有显式指定，则此处为 2
    Blue    // 原对应值默认为 2, 由于没有显式指定，而且与 Green 冲突，于是默认为 3
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

#### 结构体

在 NovaSharp 中，结构体是一种值类型，用于封装一组相关的数据。结构体可以包含属性（变量）和方法，允许包含构造函数，但不能包含析构函数或静态成员。

结构体的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] struct <结构体名>
{
    // 属性
    [<修饰符1>, <修饰符2>, ...] <类型>[] <变量名> [= <初始值>]；

    // 方法
    [<修饰符1>, <修饰符2>, ...] <返回值类型> <方法名>[<<泛型占位符列表>>](<参数列表>) [require <条件列表>]
    {
        // 方法体
    }
}
```

注意，对于结构体中的属性与函数，若没有显式声明可访问性修饰符，则默认为 `private`。

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

类是 NovaSharp 中用于封装数据和行为的基本构建块。类可以包含字段、属性、方法和事件等成员。

类的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] class <类名>
{
    // 属性
    [<修饰符1>, <修饰符2>, ...] <类型> <字段名> [= <初始值>]；

    // 方法
    [<修饰符1>, <修饰符2>, ...] <返回值类型> <方法名>(<参数列表>)
    {
        // 方法体
    }
}
```

注意，对于类中的成员，若没有显式声明可访问性修饰符，则默认为 `private`。

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

// 创建类的实例
Person willow = new Person();
willow.Name = "Willow";
willow.Age = 15;
willow.Birthday();
```

### 构造函数与析构函数

构造函数是一种特殊类型的函数，用于初始化类的实例。构造函数的名称与类名相同，并且没有返回值。在 NovaSharp 中，构造函数可以有参数，也可以重载。

构造函数的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] class <类名>
{
    // 构造函数
    public <类名>(<参数列表>)
    {
        // 初始化代码
    }
}
```

析构函数是一种特殊类型的函数，用于清理类的实例。在 NovaSharp 中，析构函数的名称与类名相同，但前面加上 `~` 符号，并且没有参数和返回值。

析构函数的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] class <类名>
{
    // 析构函数
    ~<类名>()
    {
        // 清理代码
    }
}
```

#### 继承、虚函数与密封

在 NovaSharp 中，类可以通过继承来扩展其他类的功能。子类可以继承父类的字段、属性和方法，并可以重写父类的方法以提供特定的实现。

继承的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] class <子类名> : <父类名>
{
    // 子类特有的成员
}
```

注意，NovaSharp 中的类只支持单继承，即一个类只能继承一个直接父类。而对于接口，NovaSharp 支持多重继承，即一个类可以实现多个接口。

显式声明了 `virtual` 的函数是虚函数。虚函数是允许在派生类中重写的函数。通过使用虚函数，基类可以提供默认实现，而派生类可以选择性地重写该实现。重写虚函数时，必须使用 `override` 关键字作为修饰符。

显式声明了 `sealed` 的类为密封类，不允许被继承。而对于显式声明了 `sealed` 的属性，不允许被实现或重写。

#### 接口

接口是一种特殊的引用类型，用于定义一组方法、属性和事件的契约，它不可以被实例化。类可以实现一个或多个接口，从而承诺提供接口中定义的成员。

接口的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] interface <接口名>
{
    // 方法
    <返回值类型> <方法名>(<参数列表>);

    // 属性
    <返回值类型> <属性名>;
}
```

注意，对于接口中的成员，不需要、也不能声明可访问性修饰符。

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

    public void Draw(int color) // 必须实现 Draw(int color) 函数
    {
        // 绘制圆形
    }
}
```

#### 抽象类

抽象类是一种不能被实例化的类，它通常包含一个或多个抽象属性、方法，这些方法在派生类中必须被实现。抽象类可以包含其他成员（字段、属性、方法等），这些成员可以有具体的实现。

抽象类的定义格式如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] abstract class <类名>
{
    // 属性
    [<修饰符1>, <修饰符2>, ...] <类型> <字段名> [= <初始值>]；

    // 方法
    [<修饰符1>, <修饰符2>, ...] abstract <返回值类型> <方法名>(<参数列表>);
}
```

注意，对于抽象类中的成员，若没有显式声明可访问性修饰符，则默认为 `private`。

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

#### 匿名对象

当你需要一个临时对象来传递数据，但又不想为它定义一个具体的类时，可以使用匿名对象。匿名对象可以在创建时初始化其属性，并且可以在需要时传递。

匿名对象的定义格式如下：

```novasharp
new {
    [<修饰符1>, <修饰符2>, ...] <类型> <字段名> [= <初始值>]
    ...
}
```

使用时，编译器将对匿名对象生成具名类型。可用 `var` 关键字来接收这个具名类型的实例。例如：

```novasharp
var person = new {
    Name = "Willow",
    Age = 15
};
```

### 泛型

泛型是指在定义类、接口或方法时，不指定具体的数据类型，而是使用占位符（通常是 `T`）来表示类型。这样可以在使用时指定具体的类型，从而实现代码的重用和类型安全。

以泛型类为例，泛型的基本语法如下：

```novasharp
[<修饰符1>, <修饰符2>, ...] class <类名><<占位符1>[, <占位符2>, <占位符3>, ...]>
{
    // 成员定义
}
```

泛型支持同时存在多个占位符。样例如下：

```novasharp
// 泛型类
public class Box<T, U>
{
    private T _value1;
    private U _value2;

    public Box(T value1, U value2)
    {
        _value1 = value1;
        _value2 = value2;
    }

    public T GetValue1()
    {
        return _value1;
    }

    public U GetValue2()
    {
        return _value2;
    }
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
MathOperation op = new MathOperation(new Calculator().Add);
int result = op(5, 3);
```

### Lambda

Lambda 表达式是一种简洁的表示匿名函数的方式。它可以用来创建委托或表达式树。Lambda 表达式的基本语法如下：

```novasharp
(<参数类型1> <参数名1>, <参数类型2> <参数名2>, ...) => <语句或代码块>
```

请注意。在参数类型可被推导时，可以省略参数类型。

样例如下：

```novasharp
(int a, int b) => a + b;

delegate Add(int a, int b) = (x, y) => x + y;
```

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

    public void PrintPersonData(Person person)
    {
        Console.WriteLine($"Name: {person.Name}, Age: {person.Age}");
    }
}
```

当需要引入一个命名空间下的所有子命名空间时，可以使用 `using` 指令的 `*` 通配符。例如：

```novasharp
using Standard.*;

namespace MyApplication
{
    public static void Main()
    {
        Console.WriteLine("Hello, World!"); // In namespace: Standard.IO
    }
}
```

### 异常处理

当程序运行时发生错误或异常情况时，可以使用异常处理机制来捕获和处理这些异常。在 NovaSharp 中，异常处理使用 `try`、`catch` 和 `finally` 语句块来实现。其中，`finally` 块可以被省略。

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

在 `try` 块中放置可能引发异常的代码。如果发生异常，程序会立即跳转到对应的 `catch` 块进行处理。`finally` 块中的代码无论是否发生异常都会执行，通常用于释放资源或执行清理操作。

异常类型是一专门用来处理异常信息的类。其中，`Exception` 是所有异常的基类，可以捕获所有类型的异常。

```novasharp
public class Program
{
    public static void Main()
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
        catch Exception e   // 通过堆叠 catch 块来处理不同类型的异常
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
}
```

在上面的例子中，`Divide` 方法尝试进行除法运算，如果除数为零，则会引发 `DivideByZeroException`。在 `catch` 块中捕获该异常并输出错误信息，`finally` 块中的代码始终会执行。

请注意，`finally` 块中禁止 `return`。

### 内置的异常类型

在 NovaSharp 中，内置的异常类型主要包括以下几种：

| 名称                        | 描述                                       |
| --------------------------- | ------------------------------------------ |
| `NullReferenceException`    | 当尝试访问一个为 `null` 的对象时引发。     |
| `DivideByZeroException`     | 当尝试进行零除法运算时引发。               |
| `IndexOutOfRangeException`  | 当访问数组或集合时使用了无效的索引时引发。 |
| `InvalidOperationException` | 当对象处于不适合执行操作的状态时引发。     |
| `ArgumentException`         | 当方法接收到一个无效的参数时引发。         |
| `NotImplementedException`   | 当方法尚未实现时引发。                     |
