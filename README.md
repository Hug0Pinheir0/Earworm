# 🎧 Earworm

🚀 **Earworm** é um aplicativo para ouvir podcasts via RSS Feeds. Ele permite adicionar feeds personalizados, reproduzir episódios e salvar favoritos.

## ⚡ Funcionalidades

✅ Adicionar e gerenciar feeds de podcast  
✅ Reproduzir episódios diretamente no app  
✅ Salvar episódios como favoritos  
✅ Baixar episódios para ouvir offline  
✅ Interface moderna e responsiva  

## 🛠 Tecnologias Utilizadas

- **Swift** + UIKit 🎨
- **SnapKit** para layout 📐
- **AVFoundation** para áudio 🔊
- **SDWebImage** para carregar imagens 🖼️
- **RSSFeedParser** Leitura e parsing de feeds RSS/XML para exibição de podcasts 📡


## 🔍 Decisões de Implementação

Neste projeto, foram adotadas algumas decisões técnicas para garantir **modularidade, performance e manutenibilidade**:

### 📌 Arquitetura MVP  
Utilizamos o **MVP (Model-View-Presenter)** para separar responsabilidades:  
- **Model**: Representação dos dados (episódios, feeds, etc.).  
- **View**: Interface do usuário, responsável apenas pela exibição.  
- **Presenter**: Contém a lógica de apresentação, comunicando-se com a View e o Model.  

## 🎨 UI Programática com SnapKit  
- **Eliminamos o uso de Storyboards** para evitar conflitos em merge requests.  
- **SnapKit** é utilizado para layout **dinâmico e responsivo**, garantindo flexibilidade na interface.  
- Maior **controle sobre hierarquia de views**, facilitando **animações e personalizações**.



## 📂 Estrutura do Projeto
```bash
Earworm/
│── Modules/              # Módulos principais do app
│   ├── RSSFeed/          # Tela de RSS Feeds
│   │   ├── View/         # Views e Controllers
│   │   ├── Presenter/    # Camada de Apresentação (MVP)
│   │   ├── Model/        # Modelos de dados
│   │   ├── Protocols/    # Protocolos de comunicação entre camadas
│   │   ├── Cells/        # Células customizadas para tabelas e listas
│   ├── Player/           # Player de áudio para episódios
│   ├── Favorites/        # Lista de episódios favoritos
│   ├── Downloads/        # Episódios baixados para ouvir offline
│── Networking/           # Gerenciamento de chamadas de API e RSS Feeds
│── Utils/                # Extensões, helpers e utilitários do app
│── Resources/            # Assets, imagens e fontes
│── AppDelegate.swift     # Configuração inicial do app
│── SceneDelegate.swift   # Gerenciamento de cenas no iOS
```

1️⃣ **Clone o repositório**  
```sh
git clone https://github.com/Hug0Pinheir0/Earworm.git
cd Earworm
```
2️⃣ Abra o projeto no Xcode 
```sh
open Earworm.xcworkspace
```
3️⃣  Instale as dependências

O Xcode irá automaticamente resolver e baixar todas as bibliotecas via Swift Package Manager (SPM).
Caso isso não aconteça, o usuário pode forçar a resolução manualmente:
No Xcode, vá em File > Packages > Resolve Package Versions.



