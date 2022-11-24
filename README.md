# WebCrawler
The goal of *WebCrawler* is to provide a web crawling solution fit for use in automation projects, which requires it to be able to dynamically parse common data types (without user determination) and to seamlessly handle common HTTP responses without failing.

Properly configured web servers respond to HTTP requests with headers that contain information about the data. The crawler leverages the information that is contained in an HTTP response header to determine the type of data that is contained on a web page, and subsequently return the response body parsed by the most widely used gem that is appropriate for its content type:

- [CSV](https://github.com/ruby/csv) is used to parse CSV data
- [JSON](https://github.com/flori/json) is used to parse JSON data
- [Nokogiri](https://github.com/sparklemotion/nokogiri) is used to parse CSS, HTML, and XML data
- Plaintext is returned without parsing (ie. as a string)

Additionally, the crawler implements delays in order to facilitate the highest chance of successful requests and handles resolvable HTTP responses (ex. redirections, rate limits, etc) to ensure that the data is returned if the page is available.

*Note: This project is intended to be published as a gem in the future. Currently, it needs to be cloned and required locally to run.*

#### Stack
------------
- Linux/MacOS
- [Ruby](https://www.ruby-lang.org/en/)
- [Bundler](https://bundler.io/)
- [Selenium WebDriver](https://www.selenium.dev/documentation/webdriver)

#### Installation
------------
1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
2. Install [ChromeDriver](https://sites.google.com/chromium.org/driver/downloads)
```
brew install chromedriver
```
*Note: If you are on MacOS, ensure that you trust the application:*
```
xattr -d com.apple.quarantine /usr/local/bin/chromedriver
```
3. Clone the project repository to the desired location.
```
git clone https://github.com/dsdugal/webcrawler webcrawler
```
4. Install the required gems.
```
cd webcrawler
bundle install
```
5. Require the project locally within your own project.
```
require_relative "<path_to_repository>/lib/webcrawler"
```

#### Usage
------------
Instantiate a `WebCrawler::Crawler` object and use the `get` method to return the parsed contents of a web page. The target is expected to be an `Addressable::URI`.
```
target = Addressable::URI.parse("https://www.google.ca")
crawler = WebCrawler::Crawler.new

content = crawler.get(target)
```

#### Roadmap
------------
- [x] Parse CSS, HTML, and XML content
- [x] Parse CSV content
- [x] Parse JSON content
- [x] Parse PDF content
- [x] Parse YAML content
- [x] Rate-limit HTTP requests to prevent blocking
- [ ] Use random user agent to prevent blocking
- [x] Traverse static content web pages
- [ ] Traverse dynamic content web pages
- [x] Authentication via Basic Auth
- [ ] Authentication via Digest Auth
- [ ] Authentication via NTLM
- [ ] Authentication via OAuth
- [ ] Thorough set of unit tests
- [ ] Publish as gem
