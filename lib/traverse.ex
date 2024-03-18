defmodule Traverse do
  @moduledoc """
  Documentation for `Traverse`.
  """

  @doc """
  Returns a DAG
  """
  def add_vertices(graph, list) do
    Enum.reduce(list, graph, fn {item, label}, acc ->
      label = if is_nil(label), do: [], else: label
      Graph.add_vertex(acc, item, label)
    end)
  end

  # todo determine rules for adding weights
  # . should handle the following scenarios
  # - both vertices require weight
  def add_weights(graph) do
    Graph.vertices(graph)
    |> Enum.reduce(graph, fn v, acc ->
      label_weight = get_label_weight(acc, v)

      max_weight =
        acc
        |> Graph.in_edges(v)
        |> get_max_weight(0, acc)
        |> Kernel.+(label_weight)

      acc
      |> Graph.out_edges(v)
      |> Enum.reduce(acc, fn edge, acc2 ->
        %{v1: v1, v2: v2, weight: weight} = edge
        weight = max(max_weight, weight)
        Graph.update_edge(acc2, v1, v2, weight: weight)
        # this doesn't work
        if weight > max_weight do
          acc
        else
          Graph.update_edge(acc2, v1, v2, weight: weight)
        end
      end)
    end)
  end

  def get_max_weight([], weight, _graph), do: weight

  def get_max_weight([%Graph.Edge{v2: v2, weight: edge_weight} | tail], weight, graph) do
    # look at label of v2 and add weight according ly
    label_weight = get_label_weight(graph, v2)

    weight =
      edge_weight
      |> max(weight)
      |> Kernel.+(label_weight)

    get_max_weight(tail, weight, graph)
  end

  def get_label_weight(graph, vertex) do
    if :count in Graph.vertex_labels(graph, vertex) do
      1
    else
      0
    end
  end
end
