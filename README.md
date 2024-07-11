# Visual::Qrcode

`Visual::Qrcode` gives you various tools to generate working QRCodes with images in their backgrounds, based on [this research](https://cgv.cs.nthu.edu.tw/Projects/Recreational_Graphics/Halftone_QRCodes/).

Visual example of the marianne test :


![image](/spec/images/marianne.png)
![image](/spec/images/marianne_basic_qrcode.png)
![image](/spec/images/marianne_visual_qrcode.png)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add visual-qrcode

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install visual-qrcode

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

Run `bundle exec rake` to run tests and lint. This is what runs in the CI.

You can also use `bundle exec guard` to run gard and listen to modified files to run the test

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JeSuisUnCaillou/visual-qrcode.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
