import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 44))
                .foregroundStyle(Theme.accent)
                .padding(.top, 32)

            Text("Toolbelt Ledger Pro")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.textPrimary)

            Text("Battery-health degradation charts")
                .font(Theme.bodyFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 32)

            VStack(alignment: .leading, spacing: 12) {
                Label("Unlimited entries", systemImage: "infinity")
                Label("Battery-health degradation charts", systemImage: "chart.line.uptrend.xyaxis")
            }
            .font(Theme.bodyFont)
            .foregroundStyle(Theme.textPrimary)
            .padding()
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)

            Spacer()

            Button {
                Task {
                    await purchases.purchase()
                    if purchases.isPro { dismiss() }
                }
            } label: {
                Text("Upgrade -- 3.99")
                    .font(Theme.bodyFont.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .accessibilityIdentifier("paywallUpgradeButton")
            .padding(.horizontal, 24)

            Button("Restore Purchases") {
                Task { await purchases.restore() }
            }
            .accessibilityIdentifier("paywallRestoreButton")
            .font(Theme.captionFont)
            .foregroundStyle(Theme.textSecondary)

            Button("Not Now") { dismiss() }
                .accessibilityIdentifier("paywallDismissButton")
                .font(Theme.captionFont)
                .foregroundStyle(Theme.textSecondary)
                .padding(.bottom, 24)
        }
        .background(Theme.background.ignoresSafeArea())
    }
}
