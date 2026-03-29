Structure général du projet
Une architecture modulaire t’aidera à garder un projet propre et professionnel.

📁 Arborescence recommandée
`
mint-postinstall/
│── core/
│   ├── system.sh
│   ├── updates.sh
│   ├── drivers.sh
│   └── cleanup.sh
│
│── security/
│   ├── firewall.sh
│   ├── hardening.sh
│   ├── apparmor.sh
│   └── audit.sh
│
│── apps/
│   ├── dev-tools.sh
│   ├── multimedia.sh
│   ├── office.sh
│   └── browsers.sh
│
│── network/
│   ├── dns.sh
│   ├── vpn.sh
│   └── wifi.sh
│
│── utils/
│   ├── logging.sh
│   ├── colors.sh
│   └── checks.sh
│
└── install.sh
`
