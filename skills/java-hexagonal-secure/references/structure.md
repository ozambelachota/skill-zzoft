# Reference Project Structure (Yali)

```
src/main/java/com/yali/app/sales
├── MsSalesServiceApplication.java
├── application
│   ├── port
│   │   ├── input  (Driving)
│   │   └── output (Driven)
│   └── service
│       └── (Use Case Implementations)
├── domain
│   └── model
│       └── (Entities, Value Objects)
└── infrastructure
    ├── adapter
    │   ├── input  (Controllers, Queue Listeners)
    │   └── output (JPA Repositories, Feign Clients)
    ├── config
    │   └── (Spring Config)
    └── util
```
