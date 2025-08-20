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

# 标准库 `Standard`

NovaSharp 的标准库提供了一系列**应用程序开发**中常用和必要的功能和工具，旨在完善 NovaSharp 在常规项目开发中的功能。

本文主要给出标准库中所有内容的**定义**与**部分实现**。

## IO 流 `Standard.IO`

NovaSharp 的 IO 流模块提供了一系列用于文件和数据流操作的类和方法，旨在简化程序中的输入输出操作。

### 流 `Stream`

流是数据传输的基本单元，可以是文件、网络连接或内存中的数据块。NovaSharp 的 IO 流模块提供了对这些流的抽象，使得开发者可以更方便地进行数据的读写操作。

```novasharp
public abstract class Stream
{
    // 当前流位置
    public abstract ulong Position { get; set; }

    // 长度
    public abstract long Length { get; }

    // 指示当前流是否可读
    public abstract bool CanRead { get; }

    // 指示当前流是否可写
    public abstract bool CanWrite { get; }

    // 从流中读取数据
    // buffer: 数据缓冲区
    // offset: 缓冲区偏移量
    // count: 读取字节数
    // return: 实际读取的字节数
    public abstract int Read(ref byte[] buffer, int offset, int count);

    // （重载）从流中读取数据
    // buffer: 数据缓冲区
    // offset: 缓冲区偏移量
    // count: 读取字节数
    // return: 实际读取的字节数
    public abstract int Read(ref byte[] buffer, int offset = 0);

    // 向流中写入数据
    // buffer: 数据缓冲区
    // offset: 缓冲区偏移量
    // count: 写入字节数
    public abstract void Write(byte[] buffer, int offset, int count);

    // （重载）向流中写入数据
    // buffer: 数据缓冲区
    // offset: 缓冲区偏移量
    // count: 写入字节数
    public abstract void Write(byte[] buffer, int offset = 0);

    // 刷新缓冲区，确保所有数据写入文件
    public abstract void Flush();

    // 关闭流
    public abstract void Close();
}
```

NovaSharp 的 IO 流模块支持多种类型的流，包括：

- **文件流**：用于读写文件的流。
- **网络流**：用于网络通信的流。
- **内存流**：用于在内存中读写数据的流。

开发者可以根据需要选择合适的流类型，以实现高效的数据读写操作。

### 命令行 IO 流 `Console`

NovaSharp 的命令行 IO 流模块提供了一系列用于与命令行交互的类和方法，旨在简化程序中的命令行输入输出操作。

```novasharp
namespace Standard.IO
{
    public static class Console
    {
        // 写入文本
        // message: 要写入的文本
        public static void Write(string message);

        // 写入一行文本
        // 写入时，会在 message 后添加换行符
        // message: 要写入的文本
        public static void WriteLine(string message);

        // 读取一个字符
        public static char ReadChar();

        // 读取文本
        // 读取至空格、制表符、换行符或文件结尾
        public static string Read();

        // 读取一行文本
        public static string ReadLine();
    }
}
```

### 文件操作 `Standard.IO.File`

NovaSharp 的文件操作模块提供了一系列用于文件读写的类和方法，旨在简化程序中的文件操作。

```novasharp
namespace Standard.IO.File
{
    // 尝试删除文件
    public void Delete(string path);

    // 判断文件是否存在
    public bool Exists(string path);

    // 创建文件
    public void Create(string path);

    // 尝试打开文件并将其内容替换为 content，随后关闭文件
    public void WriteText(string path, string content);

    // 尝试打开文件并将其内容替换为 content，随后关闭文件
    public void WriteBytes(string path, byte[] content);

    // 尝试打开文件并将其内容后追加 content，随后关闭文件
    // content 将被 UTF-8 编码
    public void AppendText(string path, string content);

    // 尝试打开文件并将其内容后追加 content，随后关闭文件
    public void AppendBytes(string path, byte[] content);

    // 尝试将 sourcePath 的文件内容复制到 targetPath
    // 当 targetPath 的文件已存在时，若 overrideOnExists == true，则覆盖该文件
    public void Copy(string sourcePath, string targetPath, bool overrideOnExists = false);

    // 尝试将 sourcePath 的文件内容复制到 targetPath，然后尝试删除 sourcePath 的文件
    // 当 targetPath 的文件已存在时，若 overrideOnExists == true，则覆盖该文件
    public void Move(string sourcePath, string targetPath, bool overrideOnExists = false);

    // 尝试打开文件并以 UTF-8 编码的字符串形式读取其内容，随后关闭文件
    public string ReadText(string path);

    // 尝试打开文件并以 UTF-8 编码的字符串形式读取其内容，随后关闭文件，并将读到的内容按换行符分割
    public string[] ReadLines(string path);

    // 尝试打开文件并读取其内容，随后关闭文件
    public byte[] ReadBytes(string path);
}
```

开发者可以使用 `File` 命名空间中提供的方法来方便地进行文件的打开、删除和检查是否存在等操作。

#### 文件流 `FileStream`

文件流是用于读写文件的流，支持多种文件访问模式和共享模式。开发者可以使用文件流来实现对文件的高效读写操作。

```novasharp
namespace Standard.IO.File
{
    // 文件访问模式
    public enum FileMode
    {
        CreateNew,      // 创建新文件，如果已存在则抛出异常
        Create,         // 创建新文件或覆盖现有文件
        Open,           // 打开现有文件
        OpenOrCreate,   // 打开文件或创建新文件
        Truncate,       // 打开文件并清空内容
        Append          // 打开文件并定位到末尾
    }

    // 文件访问权限
    public enum FileAccess
    {
        Read,           // 只读
        Write,          // 只写
        ReadWrite       // 读写
    }

    // 文件共享模式
    public enum FileShare
    {
        None,           // 独占访问
        Read,           // 允许其他读取
        Write,          // 允许其他写入
        ReadWrite       // 允许读写
    }

    public class FileStream : Stream
    {
        // 当前流位置
        public override ulong Position { get; set; }

        // 文件长度（字节数）
        public override long Length { get; }

        // 指示当前文件流是否可读
        public override bool CanRead { get; }

        // 指示当前文件流是否可写
        public override bool CanWrite { get; }

        // 构造函数
        // 用于打开一个文件流
        // path: 文件路径
        // mode: 文件访问模式
        // access: 文件访问权限
        // share: 文件共享模式
        public FileStream(string path, FileMode mode = FileMode.OpenOrCreate, FileAccess access = FileAccess.ReadWrite, FileShare share = FileShare.None);

        // 析构函数
        public ~FileStream()
        {
            Close();
        }

        // 从文件流中读取数据
        // buffer: 数据缓冲区
        // offset: 缓冲区偏移量
        // count: 读取字节数
        // return: 实际读取的字节数
        public override int Read(ref byte[] buffer, int offset, int count);

        // （重载）从文件流中读取数据
        // buffer: 数据缓冲区
        // offset: 缓冲区偏移量
        // count: 读取字节数
        // return: 实际读取的字节数
        public override int Read(ref byte[] buffer, int offset = 0);

        // 向文件流中写入数据
        // buffer: 数据缓冲区
        // offset: 缓冲区偏移量
        // count: 写入字节数
        public override void Write(byte[] buffer, int offset, int count);

        // （重载）向文件流中写入数据
        // buffer: 数据缓冲区
        // offset: 缓冲区偏移量
        // count: 写入字节数
        public override void Write(byte[] buffer, int offset = 0);

        // 刷新缓冲区
        public override void Flush();

        // 关闭流
        public override void Close();
    }
}
```
