import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            title: 'Desktop Compose',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: const MyHomePage(title: 'Desktop Compose'),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String composeType = "Custom";
  String osType = "LINUX";
  String dockerType = "ROOTLESS";
  List resources = [];

  String appSpecificSetting = """
  gedit:
    build: https://github.com/ysuito/desktop-compose.git#master:src/gedit
    image: gedit
    container_name: gedit
    depends_on:
      - ubuntubase
    command: ["su user -c \\\\\\"gedit\\\\\\""]
  """;
  String resultSetting = "";
  String appUsage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode),
              onPressed: () {
                MyApp.themeNotifier.value =
                    MyApp.themeNotifier.value == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
              })
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                DropdownButton<String>(
                  value: composeType,
                  items: <String>['Custom', 'Base', 'Sync'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                          width: 150.0, // for example
                          child: Text(value, textAlign: TextAlign.center),
                        ));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      composeType = val.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'OS',
                  style: TextStyle(fontSize: 16),
                ),
                CustomRadioButton(
                  elevation: 0,
                  absoluteZeroSpacing: false,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: const [
                    'Linux',
                    'WSLg',
                    'Remote',
                  ],
                  buttonValues: const [
                    "LINUX",
                    "WSLG",
                    "REMOTE",
                  ],
                  radioButtonValue: (value) {
                    osType = value.toString();
                  },
                  defaultSelected: osType,
                  selectedColor: Theme.of(context).primaryColor,
                  buttonTextStyle: const ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.grey,
                      textStyle: TextStyle(fontSize: 16)),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Docker',
                  style: TextStyle(fontSize: 16),
                ),
                CustomRadioButton(
                  elevation: 0,
                  absoluteZeroSpacing: false,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: const [
                    'Rootless',
                    'Rootfull',
                  ],
                  buttonValues: const [
                    "ROOTLESS",
                    "ROOTFULL",
                  ],
                  radioButtonValue: (value) {
                    dockerType = value.toString();
                  },
                  defaultSelected: dockerType,
                  selectedColor: Theme.of(context).primaryColor,
                  buttonTextStyle: const ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.grey,
                      textStyle: TextStyle(fontSize: 16)),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Resources',
                  style: TextStyle(fontSize: 16),
                ),
                CustomCheckBoxGroup(
                  autoWidth: true,
                  enableButtonWrap: false,
                  wrapAlignment: WrapAlignment.center,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: const [
                    "Audio",
                    "Input Method",
                    "GPU",
                  ],
                  buttonValuesList: const [
                    "AUDIO",
                    "IM",
                    "GPU",
                  ],
                  checkBoxButtonValues: (values) {
                    resources = values;
                  },
                  defaultSelected: resources,
                  horizontal: false,
                  // width: 120,
                  // hight: 50,
                  selectedColor: Theme.of(context).primaryColor,
                  buttonTextStyle: const ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.grey,
                      textStyle: TextStyle(fontSize: 16)),
                  padding: 5,
                  enableShape: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: appSpecificSetting,
                  onChanged: (text) {
                    setState(() {
                      appSpecificSetting = text;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'App specific yaml',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Config',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          createConfig();
                        },
                        child: const Text("Generate Config")),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: resultSetting));
                        },
                        child: const Text("To Clipborad"),
                        style: ElevatedButton.styleFrom(primary: Colors.amber)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                HighlightView(
                  resultSetting,
                  language: 'yaml',
                  theme: MyApp.themeNotifier.value == ThemeMode.light
                      ? githubTheme
                      : monokaiTheme,
                  padding: const EdgeInsets.all(10),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Usage',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                HighlightView(
                  appUsage,
                  language: 'markdown',
                  theme: MyApp.themeNotifier.value == ThemeMode.light
                      ? githubTheme
                      : monokaiTheme,
                  padding: const EdgeInsets.all(10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> customBaseConfig(String appName) {
    // Base setting
    return {
      "version": "3.9",
      "services": {
        appName: {
          "working_dir": "/home/user",
          "environment": [
            "UID=1000",
            "GID=1000",
            "DISPLAY=:101",
            "WAYLAND_DISPLAY",
            "XDG_RUNTIME_DIR=/tmp",
          ],
          "volumes": [
            {
              "type": "bind",
              "source": "\${XDG_RUNTIME_DIR}/wayland-0",
              "target": "/tmp/wayland-0",
            },
          ],
          "cap_add": ["CHOWN", "SETUID", "SETGID", "DAC_OVERRIDE"],
          "cap_drop": ["ALL"],
          "command": [
            "bash",
            "-c",
            "groupadd -g \$\${GID} user && "
                "useradd -s /bin/bash -u \$\${UID} -g user user && "
          ]
        }
      }
    };
  }

  Map<String, dynamic> linuxConfig(
      String appName, Map<String, dynamic> config) {
    config["services"][appName]["environment"]
        .add("XAUTHORITY=/home/user/.Xauthority");
    List<dynamic> volumes = [];
    volumes.add({
      "type": "bind",
      "source": "/tmp/.X11-unix/X0",
      "target": "/tmp/.X11-unix/X101",
    });
    volumes.add({
      "type": "bind",
      "source": "\${XAUTHORITY}",
      "target": "/auth/.Xauthority",
      "read_only": true,
    });
    volumes += config["services"][appName]["volumes"];
    config["services"][appName]["volumes"] = volumes;
    config["services"][appName]["command"].last += "chown root:root /home/user;"
        "cp /auth/.Xauthority /home/user/.Xauthority;";
    if (resources.contains("AUDIO")) {
      config["services"][appName]["environment"]
          .add("PULSE_COOKIE=/home/user/.config/pulse/cookie");
      config["services"][appName]["environment"]
          .add("PULSE_SERVER=unix:/tmp/pulse/native");
      List<dynamic> volumes = [];
      volumes.add({
        "type": "bind",
        "source": "\${XDG_RUNTIME_DIR}/pulse/native",
        "target": "/tmp/pulse/native",
      });
      volumes.add({
        "type": "bind",
        "source": "\${HOME}/.config/pulse/cookie",
        "target": "/auth/.config/pulse/cookie",
        "read_only": true,
      });
      volumes += config["services"][appName]["volumes"];
      config["services"][appName]["volumes"] = volumes;
      config["services"][appName]["command"].last +=
          "mkdir -p /home/user/.config/pulse/;"
          "cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie;";
    }
    if (resources.contains("IM")) {
      config["services"][appName]["environment"].add("GTK_IM_MODULE");
      config["services"][appName]["environment"].add("XMODIFIERS");
      config["services"][appName]["environment"].add("QT_IM_MODULE");
      config["services"][appName]["environment"]
          .add("DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/bus");
      List<dynamic> volumes = [];
      volumes.add({
        "type": "bind",
        "source": "\${XDG_RUNTIME_DIR}/bus",
        "target": "/tmp/bus",
      });
      volumes.add({
        "type": "bind",
        "source": "\${HOME}/.dbus-keyrings",
        "target": "/auth/.dbus-keyrings",
        "read_only": true,
      });
      volumes += config["services"][appName]["volumes"];
      config["services"][appName]["volumes"] = volumes;
      config["services"][appName]["command"].last +=
          "cp -R /auth/.dbus-keyrings /home/user;";
    }
    if (resources.contains("GPU")) {
      config["services"][appName]["devices"] = ["/dev/dri:/dev/dri"];
    }
    return config;
  }

  Map<String, dynamic> wslgConfig(String appName, Map<String, dynamic> config) {
    List<dynamic> volumes = [];
    volumes.add({
      "type": "bind",
      "source": "/tmp/.X11-unix/X0",
      "target": "/tmp/.X11-unix/X101",
    });
    volumes += config["services"][appName]["volumes"];
    config["services"][appName]["volumes"] = volumes;
    if (dockerType == "ROOTLESS") {
      config["services"][appName]["network_mode"] = "host";
    }
    if (resources.contains("AUDIO")) {
      config["services"][appName]["environment"]
          .add("PULSE_SERVER=unix:/tmp/pulse/native");
      List<dynamic> volumes = [];
      volumes.add({
        "type": "bind",
        "source": "\${PULSE_SERVER}",
        "target": "/tmp/pulse/native",
      });
      volumes += config["services"][appName]["volumes"];
      config["services"][appName]["volumes"] = volumes;
    }
    if (resources.contains("GPU")) {
      config["services"][appName]["devices"] = ["/dev/dxg:/dev/dxg"];
    }
    return config;
  }

  Map<String, dynamic> remoteConfig(
      String appName, Map<String, dynamic> config) {
    config["services"][appName]["environment"]
        .add("XAUTHORITY=/home/user/.Xauthority");
    List<dynamic> volumes = [];
    volumes.add({
      "type": "volume",
      "source": "x11",
      "target": "/tmp/.X11-unix/",
    });
    volumes.add({
      "type": "volume",
      "source": "auth",
      "target": "/auth/",
      "read_only": true,
    });
    volumes += config["services"][appName]["volumes"];
    config["services"][appName]["volumes"] = volumes;
    config["services"][appName]["command"].last =
        config["services"][appName]["command"].last +
            "chown root:root /home/user;"
                "cp /auth/.Xauthority /home/user/.Xauthority;";
    if (resources.contains("AUDIO")) {
      config["services"][appName]["environment"]
          .add("PULSE_SERVER=unix:/tmp/pulse/native");
      config["services"][appName]["environment"]
          .add("PULSE_COOKIE=/home/user/.config/pulse/cookie");
      config["services"][appName]["volumes"].add({
        "type": "volume",
        "source": "pulse",
        "target": "/tmp/pulse/",
      });
      config["services"][appName]["command"].last +=
          "mkdir -p /home/user/.config/pulse/;"
          "cp /auth/.config/pulse/cookie /home/user/.config/pulse/cookie;";
    }
    if (resources.contains("GPU")) {
      config["services"][appName]["devices"] = ["/dev/dri:/dev/dri"];
    }
    return config;
  }

  String linuxUsage(String appName) {
    String usage = "";
    usage += "# RUN STATELESS\n";
    usage += "\$ docker compose -f local-compose.yml run --rm -d $appName\n";
    usage += "# RUN STATEFULL\n";
    usage += "\$ docker compose -f local-compose.yml up -d $appName\n";
    usage += "# UPDATE IMAGE\n";
    usage +=
        "\$ docker compose -f local-compose.yml build --no-cache $appName\n";
    usage += "# UPDATE ALL IMAGE\n";
    usage += "\$ docker compose -f local-compose.yml build --no-cache\n";
    return usage;
  }

  String wslgUsage(String appName) {
    String usage = "";
    if (dockerType == "ROOTLESS") {
      usage += "# BUILD\n";
      usage += "\$ docker build --network=host -t $appName IMAGE_CONTEXT\n";
      usage += "# RUN STATELESS\n";
      usage += "\$ docker compose -f local-compose.yml run --rm -d $appName\n";
      usage += "# RUN STATEFULL\n";
      usage += "\$ docker compose -f local-compose.yml up -d $appName\n";
      usage += "# UPDATE IMAGE\n";
      usage +=
          "\$ docker build --no-cache --network=host -t $appName IMAGE_CONTEXT\n";
    } else {
      usage += "# RUN STATELESS\n";
      usage += "\$ docker compose -f local-compose.yml run --rm -d $appName\n";
      usage += "# RUN STATEFULL\n";
      usage += "\$ docker compose -f local-compose.yml up -d $appName\n";
      usage += "# UPDATE IMAGE\n";
      usage +=
          "\$ docker compose -f local-compose.yml build --no-cache $appName\n";
      usage += "# UPDATE ALL IMAGE\n";
      usage += "\$ docker compose -f local-compose.yml build --no-cache\n";
    }

    return usage;
  }

  String remoteUsage(String appName) {
    String usage = "";
    usage += "# CONNECT\n";
    usage += "local\$ docker compose -f local-compose.yml run --rm remote\n";
    usage += "# LAUNCH REMOTE APP STATELESS\n";
    usage +=
        "remote\$ docker compose -f remote-compose.yml run --rm -d $appName\n";
    usage += "# LAUNCH REMOTE APP STATEFULL\n";
    usage += "remote\$ docker compose -f remote-compose.yml up -d $appName\n";
    return usage;
  }

  Map<String, dynamic> appConfig(String appName, Map<String, dynamic> config,
      Map<String, dynamic> appConfig) {
    for (MapEntry e in appConfig[appName].entries) {
      if (e.key == "command") {
        // Change $HOME owner before app command execution.
        config["services"][appName]["command"].last +=
            "chown -R user:user /home/user; ";
        for (var n in e.value) {
          config["services"][appName]["command"].last += n;
        }
      } else if (config["services"][appName].containsKey(e.key)) {
        if (config["services"][appName][e.key] is List) {
          List<dynamic> values = [];
          for (var f in e.value) {
            values.add(f);
          }
          values += config["services"][appName][e.key];
          config["services"][appName][e.key] = values;
        } else if (config["services"][appName][e.key] is Map) {
          for (MapEntry g in e.value) {
            config["services"][appName][e.key][g.key] = g.value;
          }
        }
      } else {
        config["services"][appName][e.key] = e.value;
      }
    }
    return config;
  }

  void createCustomConfig() {
    Map<String, dynamic> appSpecific =
        json.decode(json.encode(loadYaml(appSpecificSetting)));
    String appName = appSpecific.entries.toList()[0].key;

    Map<String, dynamic> config = customBaseConfig(appName);
    if (osType == "LINUX") {
      config = linuxConfig(appName, config);
      setState(() {
        appUsage = linuxUsage(appName);
      });
    } else if (osType == "WSLG") {
      config = wslgConfig(appName, config);
      setState(() {
        appUsage = wslgUsage(appName);
      });
    } else if (osType == "REMOTE") {
      config = remoteConfig(appName, config);
      setState(() {
        appUsage = remoteUsage(appName);
      });
    }
    config = appConfig(appName, config, appSpecific);
    setState(() {
      resultSetting = json2yaml(config);
    });
  }

  void createConfig() {
    if (composeType == "Custom") {
      createCustomConfig();
    } else if (composeType == "Base") {
      setState(() {
        resultSetting = baseConfig();
        appUsage = """
        Save as `local-compose.yaml` in local host.
        If you want japanese environment, use  `ubuntubase_ja` instead of `ubuntubase_en`.
        Add your favorite custom app config.
        """;
      });
    } else if (composeType == "Sync") {
      setState(() {
        resultSetting = syncthingConfig();
        appUsage = """
        Add to `local-compose.yaml` or `remote-compose.yaml`.
        Edit the followings.
        - HOSTNAME
        - \${HOME}
        Exec `docker compose -f local-compose.yml run --rm -d syncthing`, to run.
        Open http://127.0.0.1:8384 in browser to configure.
        """;
      });
    }
  }

  String baseConfig() {
    String config = """
version: "3.9"

services:

  ubuntubase:
    build: https://github.com/ysuito/desktop-compose.git#master:src/ubuntubase_en
    image: ubuntubase
    container_name: ubuntubase

    """;
    return config;
  }

  String syncthingConfig() {
    Map<String, dynamic> config = {
      "version": "3.9",
      "services": {
        "syncthing": {
          "image": "syncthing/syncthing",
          "container_name": "syncthing",
          "hostname": "HOSTNAME",
          "ports": [
            "127.0.0.1:8384:8384",
            {
              "target": 22000,
              "published": 22000,
              "protocol": "tcp",
              "mode": "host",
            },
            {
              "target": 22000,
              "published": 22000,
              "protocol": "udp",
              "mode": "host"
            }
          ],
          "volumes": [
            {"type": "bind", "source": "\${HOME}", "target": "/var/syncthing"}
          ]
        }
      }
    };
    if (dockerType == "ROOTLESS") {
      if (osType == "WSLG") {
        config["services"]["syncthing"]["network_mode"] = "host";
      }
      config["services"]["syncthing"]["environment"] = [
        "PUID=0",
        "PGID=0",
      ];
    } else {
      config["services"]["syncthing"]["environment"] = [
        "PUID=1000",
        "PGID=1000",
      ];
    }
    return json2yaml(config);
  }
}
