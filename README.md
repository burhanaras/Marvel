# SwiftUI-MVVM-With-Tests
A repository to show modern MVVM with SwiftUI and automated tests.

Tech Stack: Swift, SwiftUI, Combine
Architecture: MVVM-C

Basically fetches data from MArvel API. Applies paging of 30 items. Fetches next page whenever users scrolls to the bottom.
On Detail screen, fetches Comics of the character.

API keys are stores in Plist files.
All the code is testable. Unit tests are provided and fully working.

UI is adaptive. When iPhone/iPad is rotated, column count will increase to fill the screen.
Also UI is adaptive for iPads.

In future, i will add UI tests also.
