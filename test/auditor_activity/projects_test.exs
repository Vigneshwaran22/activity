defmodule AuditorActivity.ProjectsTest do
  use AuditorActivity.DataCase

  alias AuditorActivity.Projects

  describe "work_orders" do
    alias AuditorActivity.Projects.WorkOrder

    @valid_attrs %{start_time: "2010-04-17T14:00:00Z"}
    @update_attrs %{start_time: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{start_time: nil}

    def work_order_fixture(attrs \\ %{}) do
      {:ok, work_order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_work_order()

      work_order
    end

    test "list_work_orders/0 returns all work_orders" do
      work_order = work_order_fixture()
      assert Projects.list_work_orders() == [work_order]
    end

    test "get_work_order!/1 returns the work_order with given id" do
      work_order = work_order_fixture()
      assert Projects.get_work_order!(work_order.id) == work_order
    end

    test "create_work_order/1 with valid data creates a work_order" do
      assert {:ok, %WorkOrder{} = work_order} = Projects.create_work_order(@valid_attrs)
      assert work_order.start_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_work_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_work_order(@invalid_attrs)
    end

    test "update_work_order/2 with valid data updates the work_order" do
      work_order = work_order_fixture()
      assert {:ok, %WorkOrder{} = work_order} = Projects.update_work_order(work_order, @update_attrs)
      assert work_order.start_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_work_order/2 with invalid data returns error changeset" do
      work_order = work_order_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_work_order(work_order, @invalid_attrs)
      assert work_order == Projects.get_work_order!(work_order.id)
    end

    test "delete_work_order/1 deletes the work_order" do
      work_order = work_order_fixture()
      assert {:ok, %WorkOrder{}} = Projects.delete_work_order(work_order)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_work_order!(work_order.id) end
    end

    test "change_work_order/1 returns a work_order changeset" do
      work_order = work_order_fixture()
      assert %Ecto.Changeset{} = Projects.change_work_order(work_order)
    end
  end
end
