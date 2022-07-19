# Heavy App

A starter flutter app with routing, dependency injection, pre-commit hooks and more..



## How to use 🚀

```sh
mason make heavy_app --project_name=my_app --org_name=com.myapp.app --description=Description
```



## Variables ✨

| Variable       | Description                                   | Default         | Type     |
| -------------- | --------------------------------------------- | --------------- | -------- |
| `project_name` | The project name                              | my_app          | `string` |
| `org_name`     | The organization name, acts as the bundle id. | com.example.app | `string` |
| `description`  | A short project description                   | A Very Good App | `string` |



## Bricks Used 🧱

| Brick                                              | Version |
| -------------------------------------------------- | ------- |
| [app_ui](https://brickhub.dev/bricks/app_ui/0.0.4) | 0.0.4   |



## Outputs 📦

```sh
.
├── .fvm
├── .vscode
│   ├── extensions.json
│   ├── launch.json
│   └── settings.json
├── android
├── assets
├── ios
├── lib
│   ├── app
│   │   ├── app.dart
│   │   └── view
│   │       └── app.dart
│   ├── bootstrap.dart
│   ├── features
│   │   └── counter
│   │       ├── counter.dart
│   │       ├── cubit
│   │       └── view
│   ├── gen
│   ├── generated_plugin_registrant.dart
│   ├── injection
│   │   ├── injection.dart
│   │   ├── ioc.config.dart
│   │   ├── ioc.dart
│   │   └── module.dart
│   ├── l10n
│   │   ├── arb
│   │   │   ├── app_en.arb
│   │   │   └── app_es.arb
│   │   └── l10n.dart
│   ├── main_development.dart
│   ├── main_production.dart
│   ├── main_staging.dart
│   ├── router
│   │   ├── app_router.dart
│   │   ├── app_router.gr.dart
│   │   └── router.dart
│   ├── utils
│   │   ├── log_utils
│   │   │   ├── log_utils.dart
│   │   │   └── simple_log_printer.dart
│   │   └── utils.dart
│   └── widgets
│       └── widgets.dart
├── packages
│   ├── app_ui
│   ├── auto_route_observer
│   └── bloc_logger
├── test
├── web
├── .pre-commit-config.yaml
├── analysis_options.yaml
├── coverage_badge.svg
├── flutter_native_splash.yaml
├── l10n.yaml
├── LICENSE
├── mason.yaml
├── melos_high_app.iml
├── melos.yaml
├── pubspec.lock
├── pubspec_overrides.yaml
├── pubspec.yaml
└── README.md
```



## Note

- This brick takes a while to make, I measured > 5 mins.
- For more information see [documentation](https://architecture.prnice.me/).
