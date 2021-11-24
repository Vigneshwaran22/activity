defmodule AuditorActivity.EquipmentSettings do
  import Ecto.Query, warn: false
  alias AuditorActivity.Repo
  alias AuditorActivity.Generic.{Equipment, EquipmentCategory}

  @doc """
  Returns the list of equipments.

  ## Examples

      iex> list_equipments()
      [%Equipment{}, ...]

  """
   def list_equipments(offset \\ 0, limit \\ 10, sort \\ "brand_name", order \\ "asc", search \\ "") do
    Equipment
    |> join(:left, [e], ec in assoc(e, :equipment_category))
    |> where([e, ec], e.equipment_category_id == ec.id)
    |> where([e, ec], ilike(e.brand_name, ^"%#{search}%")  or ilike(e.variant, ^"%#{search}%") or ilike(e.serial_no, ^"%#{search}%") or ilike(ec.name, ^"%#{search}%"))
    |> select([e, ec], %{id: e.id, brand_name: e.brand_name, variant: e.variant, serial_no: e.serial_no, equipment_category: ec.name})
    |> equipement_list_order_by_field(order, sort)
    |> Repo.paginate(page: offset, page_size: limit)
  end

  defp equipement_list_order_by_field(query, order, sort) do
    case {order, sort} do
      {"asc", "equipment_category"} -> query |> order_by([e, ec], asc: ec.name)
      {"desc", "equipment_category"} -> query |> order_by([e, ec], desc: ec.name)
      {_, _} -> query |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    end
  end

  @doc """
  Gets a single equipment.

  Raises `Ecto.NoResultsError` if the Equipment does not exist.

  ## Examples

      iex> get_equipment!(123)
      %Equipment{}

      iex> get_equipment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_equipment!(id), do: Equipment |> preload(:equipment_category) |> Repo.get!(id)

  @doc """
  Creates a equipment.

  ## Examples

      iex> create_equipment(%{field: value})
      {:ok, %Equipment{}}

      iex> create_equipment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_equipment(attrs \\ %{}) do
    IO.inspect attrs
    %Equipment{}
    |> Equipment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a equipment.

  ## Examples

      iex> update_equipment(equipment, %{field: new_value})
      {:ok, %Equipment{}}

      iex> update_equipment(equipment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_equipment(%Equipment{} = equipment, attrs) do
    equipment
    |> Equipment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a equipment.

  ## Examples

      iex> delete_equipment(equipment)
      {:ok, %Equipment{}}

      iex> delete_equipment(equipment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_equipment(%Equipment{} = equipment) do
    Repo.delete(equipment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking equipment changes.

  ## Examples

      iex> change_equipment(equipment)
      %Ecto.Changeset{source: %Equipment{}}

  """
  def change_equipment(%Equipment{} = equipment) do
    Equipment.changeset(equipment, %{})
  end

  @doc """
  Returns the list of equipment_categories.

  ## Examples

      iex> list_equipment_categories()
      [%EquipmentCategory{}, ...]

  """
  def list_equipment_categories(offset \\ 0, limit \\ 10, sort \\ "name", order \\ "asc", search \\ "") do
    limit =
      case limit do
        "all" -> EquipmentCategory |> select(count("*")) |> Repo.one()
        _ -> limit
      end
    EquipmentCategory
    |> order_by({^String.to_atom(order), ^String.to_atom(sort)})
    |> where([u], ilike(u.name, ^"%#{search}%") )
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @doc """
  Gets a single equipment_category.

  Raises `Ecto.NoResultsError` if the Equipment category does not exist.

  ## Examples

      iex> get_equipment_category!(123)
      %EquipmentCategory{}

      iex> get_equipment_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_equipment_category!(id), do: EquipmentCategory |> preload(:equipments) |> Repo.get!(id)

  @doc """
  Creates a equipment_category.

  ## Examples

      iex> create_equipment_category(%{field: value})
      {:ok, %EquipmentCategory{}}

      iex> create_equipment_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_equipment_category(attrs \\ %{}) do
    %EquipmentCategory{}
    |> EquipmentCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a equipment_category.

  ## Examples

      iex> update_equipment_category(equipment_category, %{field: new_value})
      {:ok, %EquipmentCategory{}}

      iex> update_equipment_category(equipment_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_equipment_category(%EquipmentCategory{} = equipment_category, attrs) do
    equipment_category
    |> EquipmentCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a equipment_category.

  ## Examples

      iex> delete_equipment_category(equipment_category)
      {:ok, %EquipmentCategory{}}

      iex> delete_equipment_category(equipment_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_equipment_category(%EquipmentCategory{} = equipment_category) do
    Repo.delete(equipment_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking equipment_category changes.

  ## Examples

      iex> change_equipment_category(equipment_category)
      %Ecto.Changeset{source: %EquipmentCategory{}}

  """
  def change_equipment_category(%EquipmentCategory{} = equipment_category) do
    EquipmentCategory.changeset(equipment_category, %{})
  end
end
