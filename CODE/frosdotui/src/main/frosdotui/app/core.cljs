
; core.cljs
;
; SPDX-FileCopyrightText: Orcro Limited <team@orcro.co.uk>
;
; SPDX-License-Identifier: Apache-2.0


; Namespace / setup

(ns frosdotui.app.core
  (:require [reagent.dom :as rdom]
            [reagent.core :as r]))


; Data

(def app-data
  "Persistent storage of data, notably, which clauses to include."
  (r/atom
    {:clause-checked []
     }))

; hard-coding some sample text

(def privacyclause "There will be some serious privacy.")
(def dataprotectionclause "Data protection is importent so it will be.")
(def liabilityclause "We hold no liability for anything under the sun, above it is another matter.")


; Functions (app functions)

; Unnecessarily complex method to modify the clause toggle. Adding/removing can now be changed separately.

(defn update-clauses!
  "Update (add or remove) clauses in app data. Do not call directly, use add-clause! or remove-clause!"
  [f & args]
  (apply swap! app-data update-in [:clause-checked] f args))

(defn add-clause!  [c]
  (update-clauses! conj c))

(defn remove-clause! [c]
  (update-clauses! (fn [cs]
                     (vec (remove #(= % c) cs)))
                   c))


; Page layout

(defn frosdot-heading
  "Title, to appear at the top of the page."
  [] ; No args
  [:h1 "FROSDOT"])

(defn frosdot-subheading
  "Full title 'free and open source document templates' capitalised and coloured with Orcro red."
  [] ; No args
  [:div
   [:p
    [:span {:style {:color "#e6523b"}} [:strong "Fr"]]
    "ee and "
    [:span {:style {:color "#e6523b"}} [:strong "O"]]
    "pen "
    [:span {:style {:color "#e6523b"}} [:strong "S"]]
    "ource "
    [:span {:style {:color "#e6523b"}} [:strong "Do"]]
    "cument "
    [:span {:style {:color "#e6523b"}} [:strong "T"]]
    "emplates"]])

(defn privacy-clause-checkbox
  "Privacy clause checkbox, when ticked, displays this clause."
  [] ; No args
  [:p
   [:input {:type "checkbox"
            :onClick (fn [e] (if (.. e -target -checked)
                               (add-clause! :privacy)
                               (remove-clause! :privacy)))
            :defaultChecked false}]
   "Privacy Clause"
   ])

(defn dataprotection-clause-checkbox
  "Data protection clause checkbox, when ticked, displays this clause."
  [] ; No args
  [:p
   [:input {:type "checkbox"
            :onClick (fn [e] (if (.. e -target -checked)
                               (add-clause! :dataprotect)
                               (remove-clause! :dataprotect)))
            :defaultChecked false}]
   "Data Protection"
   ])

(defn liability-clause-checkbox
  "Liability clause checkbox, when ticked, displays this clause."
  [] ; No args
  [:p
   [:input {:type "checkbox"
            :onClick (fn [e] (if (.. e -target -checked)
                               (add-clause! :liability)
                               (remove-clause! :liability)))
            :defaultChecked false}]
   "Liability Clause"
   ])

(defn show-clause
  "HTML element to add list item in clause-list."
  [c]
  (case c
    :privacy [:li
              [:span privacyclause]]
    :dataprotect [:li
                  [:span dataprotectionclause]]
    :liability [:li
                [:span liabilityclause]]))

(defn clause-list
  "Display selected clauses."
  []
  [:div
   [:h2 "Clauses checked"]
   [:ul
    (for [c (:clause-checked @app-data)]
      [show-clause c])]])



; Testing ground

(defn submit-image-form []
  [:div "Submit using html"
   [:form {:action "/upload-image"
           :enc-type "multipart/form-data"
           :method "post"}
    [:input {:type "file"
             :name "myfileup"}]
    [:button {:type "submit"}
     "Submit image form"]]])

; (defn file-blob [datamap mimetype]
;   (js/Blob. [(with-out-str (cljs.pprint/pprint datamap))] {"type" mimetype}))
;
; (defn link-for-blob [blob filename]
;   (doto (.createElement js/document "a")
;     (set! -download filename)
;     (set! -href (.createObjectURL js/URL blob))))
;
; (defn click-and-remove-link [link]
;   (let [click-remove-callback
;         (fn []
;           (.dispatchEvent link (js/MouseEvent. "click"))
;           (.removeChild (.-body js/document) link))]
;     (.requestAnimationFrame js/window click-remove-callback)))
;
; (defn add-link [link]
;   (.appendChild (.-body js/document) link))
;
; (defn download-data [data filename mimetype]
;   (-> data
;       (file-blob mimetype)
;       (link-for-blob filename)
;       add-link
;       click-and-remove-link))
;
; (defn export-data []
;   (download-data "this is to go" "export.txt" "text/plain"))

(defn to-json [v] (.stringify js/JSON v))

(defn download-object-as-json [value export-name]
        (let [data-blob (js/Blob. #js [(to-json value)] #js {:type "application/json"})
                  link (.createElement js/document "a")]
          (set! (.-href link) (.createObjectURL js/URL data-blob))
          (.setAttribute link "download" export-name)
          (.appendChild (.-body js/document) link)
          (.click link)
          (.removeChild (.-body js/document) link)))

; test button
(defn test-download
  []
  [:input {:type "button"
           :value "Download test"
           :on-click #(download-object-as-json (clj->js {:hello "world"}) "myfile.json")}])

; Application func.

(defn app []
  [:div
   [frosdot-heading]
   [frosdot-subheading]
   [privacy-clause-checkbox]
   [dataprotection-clause-checkbox]
   [liability-clause-checkbox]
   [clause-list]
   [submit-image-form]
   [test-download]])


; Required render and reloads.

(defn render []
  (rdom/render [app] (.getElementById js/document "root")))

(defn ^:export main []
  (render))

(defn ^:dev/after-load reload! []
  (render))

