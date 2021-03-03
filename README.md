




<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** b-enji-cmd, relational-rails, twitter_handle, email, project_title, project_description
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->







<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>



### Built With

* [Ruby on Rails](https://rubyonrails.org)
* [HTML](https://html.com)
* [JavaScript](https://www.javascript.com)
* [Bootstrap](https://getbootstrap.com/)


## Database Design Document
![Database Design Document](https://user-images.githubusercontent.com/72330302/109873878-9d558e80-7c2b-11eb-82fa-85a796040336.png)


<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* rails
  ```sh
  gem install rails --version 5.2.4.3
  ```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/Gvieve/little-esty-shop.git
   ```
2. Bundle Install
   ```sh
   bundle install
   ```



<!-- USAGE EXAMPLES -->
## Usage

1. Start rails server
```sh
$ rails s
```
2. Create rails database and migrate
```sh
$ rails db:create
$ rails db:migrate
```
3. Seed development database

    * This will load all csv files located inside the `db/data` directory.

  ```sh
  $ rails csv_load:all
  ```

    * To load a single table, where <table> is merchants or items, etc: 

  ```sh
  $ rails csv_load:<table>
  ```

4. Seed test database

    * This will load all csv fixtures files located inside the `spec/fixtures/files` directory. You will need this test data to run the existing test suite.

  ```sh
  $ rails db:seed RAILS_ENV=test
  ```

5. Nagivate to `http://localhost:3000/`

  The welcome page currently has no links because future iterations would include the ability to authenticate users. The idea is the links on the welcome page would be dynamic based on the users role.

* __Merchant Dashboard__

  Select a single merchant id from the data set that you wish to view. Navigate to `http://localhost:3000/merchant/:id/dashboard`, where :id field is the id of the merchant you wish to view.

  The merchant dashboard is intended for merchants to view business statistics to help understand their best customers based on successful transactions. Or take action on items that are ready to ship.

  Within items a merchant can manage all of the items they sell, including disabling or enabling. Within invoices a mercahnt can take action on any invoice associated to their merchant, and update the status of any given item.

* __Admin Dashboard__

  Navigate to `http://localhost:3000/admin`.

  Admin dashboard is intended for the owner of the site to manage their merchants, all invoices and gain insight on their top customers.

  Within merchants one can enable, create or disable merchants. As well as see top performers base on total revenue. Within invoices the administrator can take action on any invoice that is not yet complete.

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/Gvieve/little-esty-shop/issues) for a list of proposed features (and known issues). Please open an issue ticket if you see an existing error or bug.



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the power of us, we suppose...
