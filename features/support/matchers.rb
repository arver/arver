RSpec::Matchers.define :contain do |expected|
  match do |actual|
    actual.include?( expected )
  end
end
