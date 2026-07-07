import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showSettings = false
    @State private var showPaywall = false

    @State private var newValue: Double = 8.0
    @AppStorage("targetValue") private var targetValue: Double = 8.0

    var total: Double { store.entries.map(\.value).reduce(0, +) }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Running Total").font(Theme.headlineFont).foregroundStyle(Theme.primary)
                        Spacer()
                        Text(String(format: "%.1f", total)).font(Theme.headlineFont).foregroundStyle(Theme.accent)
                    }
                    Stepper("Target Hours: \(String(format: "%.1f", targetValue))", value: $targetValue, in: 0...48, step: 0.5)
                        .accessibilityIdentifier("targetStepper")
                }
                .listRowBackground(Theme.cardBackground)

                ForEach(store.entries) { entry in
                    HStack {
                        Text(entry.date, style: .date).font(Theme.bodyFont).foregroundStyle(Theme.primary)
                        Spacer()
                        Text(String(format: "%.1f", entry.value)).font(Theme.bodyFont).foregroundStyle(Theme.secondary)
                    }
                    .listRowBackground(Theme.cardBackground)
                }
                .onDelete(perform: store.delete)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Sleepdebt")

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.isAtLimit && !purchases.isPro {
                            showPaywall = true
                        } else {
                            showAddSheet = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
            .sheet(isPresented: $showPaywall) { PaywallView() }

            .sheet(isPresented: $showAddSheet) {
                NavigationStack {
                    Form {
                        Stepper("Hours Slept: \(String(format: "%.1f", newValue))", value: $newValue, in: 0...24, step: 0.25)
                            .accessibilityIdentifier("valueStepper")
                    }
                    .navigationTitle("New Entry")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAddSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                store.add(Entry(date: Date(), value: newValue))
                                showAddSheet = false
                            }
                            .accessibilityIdentifier("saveEntryButton")
                        }
                    }
                }
            }
        }
    }
}
