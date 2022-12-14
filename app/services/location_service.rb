# frozen_string_literal: true

# Location Service used to find closest survivor
class LocationService
  attr_reader :survivor, :closest_survivor, :requester_latitude, :requester_longitude

  LATITUDE_SIZE = 90
  LONGITUDE_SIZE = 180

  def self.call(survivor)
    new(survivor).closest_survivor
  end

  private

  def initialize(survivor)
    @survivor = survivor
    @requester_latitude = survivor.position.latitude
    @requester_longitude = survivor.position.longitude
    @closest_survivor = fecth_closer_survivor&.first&.survivor
  end

  def fecth_closer_survivor
    search_size = LONGITUDE_SIZE + 1
    positions = []
    search_size.times do |search_scope|
      positions = search_positions_dinamyc_query(search_scope).where.not(id: survivor.position.id)
      break if positions.any?
    end

    positions = build_raw_positions_with_values(positions)

    positions = sort_raw_positions(positions)

    positions.pluck(:position)
  end

  def build_raw_positions_with_values(positions)
    positions.map do |position|
      { position: position,
        latitude_value: (requester_latitude.abs - position.latitude.abs).abs.round,
        longitude_value: (requester_longitude.abs - position.longitude.abs).abs.round }
    end
  end

  def sort_raw_positions(positions)
    positions.sort do |a, b|
      first_values, first_value = define_position_values_by_least_common_multiple(a)
      second_values, second_value = define_position_values_by_least_common_multiple(b)

      if first_value == second_value
        first_values <=> second_values
      else
        first_value <=> second_value
      end
    end
  end

  def define_position_values_by_least_common_multiple(position)
    values = [position[:longitude_value].round, position[:latitude_value].round].sort
    value = if [0, 1].include? values.first
              values.last - 0.1
            else
              values.last.lcm values.first
            end
    [values, value]
  end

  def search_positions_dinamyc_query(search_scope)
    result = Position.where(latitude: default_range(requester_latitude, search_scope),
                            longitude: default_range(requester_longitude, search_scope))

    search_longitude_offset_range(search_scope).each { |range| result = result.or(Position.where(longitude: range)) }
    search_latitude_offset_range(search_scope).each { |range| result = result.or(Position.where(latitude: range)) }

    result
  end

  def default_range(position, size)
    (position - size)..(position + size)
  end

  def search_latitude_offset_range(search_size)
    search_offset(search_size, LATITUDE_SIZE, requester_latitude, 'latitude')
  end

  def search_longitude_offset_range(search_size)
    search_offset(search_size, LONGITUDE_SIZE, requester_longitude, 'longitude')
  end

  def search_offset(search_size, constant_size, requester_axis_distance, axis)
    case axis
    when 'longitude'
      botom_offset, upper_offset = set_longitude_offset_limits(search_size, constant_size, requester_axis_distance)
    when 'latitude'
      botom_offset, upper_offset = set_latitude_offset_limits(search_size, constant_size, requester_axis_distance)
    end

    set_extra_range(upper_offset, botom_offset, constant_size)
  end

  def set_longitude_offset_limits(search_size, constant_size, requester_axis_distance)
    if longitude_over_limit?(search_size)
      botom_offset = calculate_offset(search_size, constant_size, requester_axis_distance, 'bottom')
    end
    if longitude_under_limit?(search_size)
      upper_offset = calculate_offset(search_size, constant_size, requester_axis_distance, 'upper')
    end
    [botom_offset, upper_offset].compact
  end

  def set_latitude_offset_limits(search_size, constant_size, requester_axis_distance)
    if latitude_over_limit?(search_size)
      botom_offset = calculate_offset(search_size, constant_size, requester_axis_distance, 'bottom')
    end
    if latitude_under_limit?(search_size)
      upper_offset = calculate_offset(search_size, constant_size, requester_axis_distance, 'upper')
    end
    [botom_offset, upper_offset].compact
  end

  def set_extra_range(upper_offset, botom_offset, constant_size)
    extra_range = []

    extra_range << (-constant_size..botom_offset) if botom_offset
    extra_range << (upper_offset..constant_size) if upper_offset

    extra_range
  end

  def calculate_offset(search_size, constant_size, requester_axis_distance, direction)
    return (-constant_size + ((requester_axis_distance + search_size) - constant_size)) if direction == 'bottom'

    (constant_size + ((requester_axis_distance - search_size) + constant_size)) if direction == 'upper'
  end

  def latitude_over_limit?(search_size)
    !!((requester_latitude + search_size) >= LATITUDE_SIZE)
  end

  def latitude_under_limit?(search_size)
    !!((requester_latitude - search_size) <= -LATITUDE_SIZE)
  end

  def longitude_over_limit?(search_size)
    !!((requester_longitude + search_size) >= LONGITUDE_SIZE)
  end

  def longitude_under_limit?(search_size)
    !!((requester_longitude - search_size) <= -LONGITUDE_SIZE)
  end
end
