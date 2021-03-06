# nordigen_integration

[![License](https://img.shields.io/github/license/dhi13man/nordigen_integration)](https://github.com/Dhi13man/nordigen_integration/blob/main/LICENSE)
[![Contributors](https://img.shields.io/github/contributors-anon/dhi13man/nordigen_integration?style=flat)](https://github.com/Dhi13man/nordigen_integration/graphs/contributors)
[![GitHub forks](https://img.shields.io/github/forks/dhi13man/nordigen_integration?style=social)](https://github.com/Dhi13man/nordigen_integration/network/members)
[![GitHub Repo stars](https://img.shields.io/github/stars/dhi13man/nordigen_integration?style=social)](https://github.com/Dhi13man/nordigen_integration)
[![Last Commit](https://img.shields.io/github/last-commit/dhi13man/nordigen_integration)](https://github.com/Dhi13man/nordigen_integration/commits/main)

Thank you for investing your time in contributing to this project! Any contributions you make have a chance of reflecting in [the actual Package on Pub.dev](https://pub.dev/packages/nordigen_integration), and brightens up my day. :)

Make sure you view [Nordigen's Account Information API documentation](https://nordigen.com/en/account_information_documenation/integration/quickstart_guide/) first before contributing!

## General Steps to Contribute

1. Ensure you have [Dart](https://dart.dev/get-dart)/[Flutter](https://flutter.dev/docs/get-started/install) SDK installed.

2. Fork the [project repository](https://github.com/Dhi13man/nordigen_integration).

3. Clone the forked repository by running `git clone <forked-repository-git-url>`.

4. Navigate to your local repository by running `cd nordigen_integration`.

5. Pull the latest changes from upstream into your local repository by running `git pull`.

6. Create a new branch by running `git checkout -b <new-branch-name>`.

7. Make changes in your local repository to make the contribution you want.
    1. Data Model files go to `./lib/src/models/`.
    2. API files go to `./lib/src/services/`.

8. Add relevant tests (if any) for the contribution you made to `./test` folder and an appropriate subfolder.

9. **[Get an API Access Token](https://ob.nordigen.com)** if you haven't already, and set it as the `accessToken` constant in `./test/nordigen_integration_test.dart` in place of `'test'`.

10. Run `dart test` to run the tests. **Ensure all tests run and pass before committing and/or pushing!**

11. **Replace your `accessToken` with `'test'` again before committing and/or pushing**, or it will get leaked!

12. Commit your changes and push them to your local repository by running `git commit -am "my-commit-message" && git push origin <new-branch-name>`.

13. Create a pull request on the original repository from your fork and wait for me to review (and hopefully merge) it. :)

### Recommended Development Workflow

- Fork Project **->** Create new Branch
- For each contribution in mind,
  - **->** Develop Data Models
  - **->** Develop API Bindings
  - **->** Test
  - **->** Ensure Documentation is sufficient
  - **->** Commit
- Create Pull Request

## Issue Based Contributions

### Create a new issue

If you spot a problem or bug with the package, search if an [issue](https://www.github.com/dhi13man/nordigen_integration/issues) already exists. If a related issue doesn't exist, you can open a new issue using a relevant issue form.

### Solve an issue

Scan through our existing [issues](https://www.github.com/dhi13man/nordigen_integration/issues) to find one that interests you. You can narrow down the search using labels as filters. See Labels for more information.

## Overall Guidelines

- Contributions are welcome on [GitHub](https://www.github.com/dhi13man/nordigen_integration). Please ensure all the tests are running before pushing your changes. Write your own tests too!

- File any [issues or feature requests here,](https://www.github.com/dhi13man/nordigen_integration/issues) or help me resolve existing ones. :)
