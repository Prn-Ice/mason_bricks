# Brick starter

A brick that generates a basic brick.



## How to use 🚀

```sh
mason make brick_starter --name hello --description foo --author bar --hooks true
```



## Variables ✨

| Variable      | Description                      | Default           | Type     |
| ------------- | -------------------------------- | ----------------- | -------- |
| `name`        | The name of the brick            | basic             | `string` |
| `description` | A brief description of the brick | A very good brick | `string` |
| `author`      | The author of the brick          | me                | `string` |
| `hooks`      | Whether or not hooks should be generated for this brick | true                | `boolean` |



## Outputs 📦

```sh
name
├── CHANGELOG.md
├── LICENSE
├── README.md
├── __brick__
│   └── HELLO.md
├── hooks
│   |── post_gen.dart
│   |── pre_gen.dart
│   └── pubspec.yaml
└── brick.yaml
```
