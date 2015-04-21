require 'spec_helper'

describe Stretchy::Filters::RangeFilter do

  subject { Stretchy::Filters::RangeFilter }
  let(:field) { 'salary' }
  let(:date_field) { 'first_game' }
  let(:min) { 850000 }
  let(:max) { 950000 }
  let(:one_day) { 60*60*24 }
  let(:min_date) { Time.now - one_day }
  let(:max_date) { Time.now + one_day }

  def get_result(*args)
    subject.new(*args).to_search[:range]
  end

  it 'returns json for range filter' do
    result = get_result(field: field, min: min, max: max)
    expect(result[field]).to be_a(Hash)
    expect(result[field][:gte]).to eq(min)
    expect(result[field][:lte]).to eq(max)
  end

  it 'accepts dates for min / max' do
    result = get_result(field: date_field, min: min_date, max: max_date)
    expect(result[date_field][:gte]).to eq(min_date)
    expect(result[date_field][:lte]).to eq(max_date)
  end

  xit 'max field is optional' do
    result = get_result(field: field, min: min)
    expect(result[field][:gte]).to eq(min)
    expect(result[field][:lte]).to be_nil
  end

  xit 'min field is optional' do
    result = get_result(field: field, max: max)
    expect(result[field][:gte]).to be_nil
    expect(result[field][:lte]).to eq(max)
  end

  xit 'raises error unless min or max present' do
    expect{subject.new(field: field)}.to raise_error
  end

  it 'raises error unless min and max are approriate types' do
    expect{subject.new(field: field, min: 'wat')}.to raise_error
    expect{subject.new(field: field, max: 'wat')}.to raise_error
  end
end