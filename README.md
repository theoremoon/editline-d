# editline-d

binding for libedit(editline) library made by dstep

## Usage

```dub.json
"dependencies": {
  "editline-d": "~>0.0.1"
}
```

```source/app.d
import std.stdio;
import std.string;
import editline;

void main()
{
  while (true) {
    auto line = readline(">");
    if (line is null) {
      break;
    }
    add_history(line);

    writeln(line.fromStringz());
  }
  clear_history();
}
```

## LISENCE

MIT
