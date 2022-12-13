use dioxus::{
    desktop::tao::window::Icon,
    prelude::*,
    router::{Link, Route, Router},
};
use serde_json::Value;
use std::{include_bytes, include_str};
use urlencoding::decode;

fn main() {
    let icon_data = include_bytes!(concat!(
        env!("CARGO_MANIFEST_DIR"),
        "/assets/images/kannada-bible.png"
    ));
    let (icon_rgba, icon_width, icon_height) = {
        let image = image::load_from_memory(icon_data)
            .expect("Failed to include icon png")
            .into_rgba8();
        let (width, height) = image.dimensions();
        let rgba = image.into_raw();
        (rgba, width, height)
    };
    let icon = Icon::from_rgba(icon_rgba, icon_width, icon_height).expect("Failed to open icon");
    dioxus::desktop::launch_cfg(App, |c| {
        c.with_window(|w| {
            w.with_title("Kannada Bible App")
                .with_maximized(true)
                .with_window_icon(Some(icon))
        })
    });
}

fn Home(cx: Scope) -> Element {
    cx.render(rsx! {
        div {
            "Home"
        },
        Redirect { to: "/Genesis/1"}
    })
}

fn NotFound(cx: Scope) -> Element {
    cx.render(rsx! {
        div {
            "Not Found"
        }
    })
}

#[inline_props]
fn BibleList(cx: Scope, values: Vec<String>) -> Element {
    cx.render(rsx! {
        div {
            ul { list_style: "none", display: "flex", flex_direction: "column",
                values.iter().map(|b| rsx!(
                    li {
                      Link { to: "/{b}/1", "{b}"}
                    }
                ))
            },
        }
    })
}

fn Page(cx: Scope) -> Element {
    let route = use_route(&cx);
    let selected = use_state(&cx, || std::vec::Vec::<usize>::new());
    let book = decode(route.segment("book").unwrap())
        .unwrap()
        .as_ref()
        .to_owned();
    let chapter = route.segment("chapter").unwrap().parse::<usize>().unwrap();
    let data = include_str!("../assets/kannada.json");
    let bible_json: Value = serde_json::from_str::<Value>(data).unwrap().clone();
    let old_testament = bible_json
        .as_object()
        .unwrap()
        .keys()
        .take(39)
        .map(|s| s.to_owned())
        .collect::<Vec<_>>();
    let new_testament = bible_json
        .as_object()
        .unwrap()
        .keys()
        .skip(39)
        .map(|s| s.to_owned())
        .collect::<Vec<_>>();
    let verses = &bible_json[book.clone()][chapter - 1].as_array().unwrap();
    cx.render(rsx! {
        div { font_size: "16px", font_family: "Helvetica Neue", width: "100%", height: "100%", display: "flex", flex_direction: "row",
            div { display: "flex", flex_direction: "row",
                rsx!(BibleList {values: old_testament}),
                rsx!(BibleList {values: new_testament}),
            },
            div { display: "flex", flex_direction: "column",
                div { font_size: "32px",
                    "Page {book} {chapter}",
                },
                ul { list_style: "none",
                    verses.iter().enumerate().map(|(i, v)| {
                        let verse_selected = selected.contains(&i);
                        let color = if verse_selected { "yellow" } else { "white" } ;
                        rsx!(
                            li {
                                cursor: "pointer",
                                user_select: "none",
                                margin: "10px 0",
                                background_color: "{color}",
                                onclick: move |_| {
                                    let mut new_vec = selected.get().clone();
                                    if !verse_selected {
                                      new_vec.push(i);
                                    } else {
                                        new_vec.retain(|v| *v != i);
                                    }
                                    selected.set(new_vec);
                                },   
                                "{v}"
                            }
                        )
                    })
                }
            }
        }
    })
}

fn App(cx: Scope) -> Element {
    cx.render(rsx! {
        Router {
            Route { to: "/", Home {} }
            Route { to: "/:book/:chapter", Page{} }
            Route { to: "", NotFound {} }
        }
    })
}
