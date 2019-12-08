# Contributing

When contributing to this repository, please discuss the changes you wish to make by submitting an [issue](https://github.com/fliverdev/rider/issues) first. It helps us understand your proposal in advance and discuss wether it is necessary or not.

Alternatively, you can contribute to resolve any of the [open issues](https://github.com/fliverdev/rider/issues) without the need for prior discussion.

## Pull Requests

**Important:** this project contains certain files that are encrypted due to the use of API keys, which is why it will not build directly on your machine. Please refer to [ENCRYPTION.md](ENCRYPTION.md) for more information.

Please follow these exact steps for sending us a pull request:

-   Make sure that an issue regarding your proposal is open (by you or someone else).
-   Fork this repository and clone the fork to your local machine.
-   Checkout the `dev` branch for the latest development progress using `git checkout dev`.
-   Replace all the encrypted files with your own as explained in [ENCRYPTION.md](ENCRYPTION.md).
-   **Important:** When committing changes, ensure that you deselect/unstage the encrypted files that you locally modified in the previous step. If you commit your own encrypted files, **we will not merge your pull request**.
-   Send us a pull request from `your-username:dev` to `fliverdev:dev`.
-   Your PR will be merged if satisfactory.
