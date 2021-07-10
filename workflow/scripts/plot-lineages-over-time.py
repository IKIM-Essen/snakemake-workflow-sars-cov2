sys.stderr = open(snakemake.log[0], "w")

import pandas as pd
import altair as alt


def plot_lineages_over_time(sm_input, sm_output, dates):
    pangolin_outputs = []
    for call, date in zip(sm_input, dates):
        pangolin_call = pd.read_csv(call)
        pangolin_call["date"] = date
        pangolin_outputs.append(pangolin_call)

    pangolin_calls = pd.concat(pangolin_outputs, axis=0, ignore_index=True)
    pangolin_calls = pangolin_calls[pangolin_calls["lineage"] != "None"]

    # get occurrences
    pangolin_calls["lineage_count"] = pangolin_calls.groupby("lineage", as_index=False)[
        "lineage"
    ].transform(lambda s: s.count())

    # mask low occurrences
    pangolin_calls.loc[
        pangolin_calls["lineage_count"] < 10, "lineage"
    ] = "other (< 10 occ.)"

    source = pangolin_calls.copy()
    source.rename(columns={"lineage": "Lineage", "date": "Date"}, inplace=True)

    area_plot = (
        alt.Chart(source)
        .mark_area(opacity=0.5, interpolate="monotone")
        .encode(
            x=alt.X("Date:T", scale=alt.Scale(nice={"interval": "day", "step": 7})),
            y=alt.Y("count()", stack=True),
            stroke="Lineage",
            color=alt.Color(
                "Lineage",
                scale=alt.Scale(scheme="tableau10"),
                legend=alt.Legend(orient="top"),
            ),
        )
    ).properties(width=800)

    area_plot.save(sm_output)


if __name__ == "__main__":
    dates = snakemake.params.get("dates", "")
    plot_lineages_over_time(snakemake.input, snakemake.output[0], dates)
