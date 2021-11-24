defmodule AuditorActivity.TimezoneSetting do
  alias AuditorActivity.Generic.Timezone
  alias AuditorActivity.Repo

  @doc """
  Returns the list of timezones.

  ## Examples

      iex> list_timezones()
      [%Timezone{}, ...]

  """
  def list_timezones do
    Timezone
    |> Repo.all()
    # |> IO.inspect
    # from(t in Timezone, order_by: [asc: :utc_offset_seconds])
    # |> Repo.all()
  end

  @doc """
  Gets a single timezone.

  Raises `Ecto.NoResultsError` if the Timezone does not exist.

  ## Examples

      iex> get_timezone!(123)
      %Timezone{}

      iex> get_timezone!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timezone!(id), do: Repo.get!(Timezone, id)

  @doc """
  Creates a timezone.

  ## Examples

      iex> create_timezone(%{field: value})
      {:ok, %Timezone{}}

      iex> create_timezone(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timezone(attrs \\ %{}) do
    %Timezone{}
    |> Timezone.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timezone.

  ## Examples

      iex> update_timezone(timezone, %{field: new_value})
      {:ok, %Timezone{}}

      iex> update_timezone(timezone, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timezone(%Timezone{} = timezone, attrs) do
    timezone
    |> Timezone.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a timezone.

  ## Examples

      iex> delete_timezone(timezone)
      {:ok, %Timezone{}}

      iex> delete_timezone(timezone)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timezone(%Timezone{} = timezone) do
    Repo.delete(timezone)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timezone changes.

  ## Examples

      iex> change_timezone(timezone)
      %Ecto.Changeset{source: %Timezone{}}

  """
  def change_timezone(%Timezone{} = timezone) do
    Timezone.changeset(timezone, %{})
  end

  def build_tzdb() do
    Tzdata.canonical_zone_list()
    |> Enum.reduce([], &make_tzmap/2)
    |> Enum.map(fn entry ->
      create_timezone(entry)
      # cs = Timezone.changeset(%Timezone{}, entry)
      # err = Repo.get_errors(cs)
      # save(err, cs)
    end)
  end

  defp make_tzmap(continent_city, tzmaplist) do
    case String.split(continent_city, "/") do
      [conti | [city]] ->
        [
          %{
            continent: conti,
            label: continent_city,
            state: "",
            city: String.replace(city, "_", " "),
            city_low: String.replace(city, "_", " ") |> lower_city(),
            city_stripped: String.replace(city, "_", " ") |> stripped_lower_city(),
            offset: find_utc_offset(continent_city),
            utc_offset_seconds: get_utc_off(continent_city)
          }
          | tzmaplist
        ]

      [conti | [state | [city]]] ->
        [
          %{
            continent: conti,
            label: continent_city,
            state: state,
            city: String.replace(city, "_", " "),
            city_low: String.replace(city, "_", " ") |> lower_city(),
            city_stripped: String.replace(city, "_", " ") |> stripped_lower_city(),
            offset: find_utc_offset(continent_city),
            utc_offset_seconds: get_utc_off(continent_city)
          }
          | tzmaplist
        ]

      _ ->
        tzmaplist
    end
  end

  defp lower_city(city) do
    String.downcase(city)
  end

  defp stripped_lower_city(city) do
    lower_city(city) |> String.replace(" ", "")
  end

  defp get_utc_off(tz) do
    {:ok, pl} = Tzdata.periods(tz)
    [period_selected | []] = Enum.filter(pl, fn p -> p.until.utc == :max end) |> Enum.take(1)
    utc_offset = Map.get(period_selected, :utc_off)

    if utc_offset != nil do
      utc_offset
    else
      IO.puts("#{tz} : #{inspect(period_selected)}")
    end
  end

  defp find_utc_offset(tz) do
    {:ok, pl} = Tzdata.periods(tz)
    [period_selected | []] = Enum.filter(pl, fn p -> p.until.utc == :max end) |> Enum.take(1)
    utc_offset = Map.get(period_selected, :utc_off)

    if utc_offset != nil do
      make_utc_offset_string(period_selected.utc_off)
    else
      IO.puts("#{tz} : #{inspect(period_selected)}")
    end
  end

  defp make_utc_offset_string(seconds) do
    {sign, secs} =
      case seconds < 0 do
        true -> {"-", seconds * -1}
        false -> {"+", seconds}
      end

    m = div(secs, 60)
    hours = div(m, 60)
    mins = rem(m, 60)

    str_mins =
      case mins < 10 do
        true -> "0" <> to_string(mins)
        false -> to_string(mins)
      end

    "UTC" <> sign <> to_string(hours) <> ":" <> str_mins
  end

  def blank?(nil), do: ""

  def blank?(givenString) do
    case String.trim(givenString) |> String.length() do
      0 -> ""
      _ -> "," <> givenString
    end
  end
end
